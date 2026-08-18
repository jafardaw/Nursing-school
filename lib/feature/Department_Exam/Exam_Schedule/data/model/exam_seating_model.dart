class ExamSeatingModel {
  final int id;
  final int examScheduleId;
  final int studentId;
  final int hallId;
  final int seatNumber;
  final String studentName;
  final String hallName;
  final int hallCapacity;

  const ExamSeatingModel({
    required this.id,
    required this.examScheduleId,
    required this.studentId,
    required this.hallId,
    required this.seatNumber,
    required this.studentName,
    required this.hallName,
    required this.hallCapacity,
  });

  factory ExamSeatingModel.fromJson(Map<String, dynamic> json) {
    final student = json['student'] is Map<String, dynamic>
        ? json['student'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final hall = json['hall'] is Map<String, dynamic>
        ? json['hall'] as Map<String, dynamic>
        : const <String, dynamic>{};

    int asInt(dynamic value) =>
        value is int ? value : int.tryParse('$value') ?? 0;

    return ExamSeatingModel(
      id: asInt(json['id']),
      examScheduleId: asInt(json['exam_schedule_id']),
      studentId: asInt(json['student_id']),
      hallId: asInt(json['hall_id']),
      seatNumber: asInt(json['seat_number']),
      studentName: '${student['full_name'] ?? ''}',
      hallName: '${hall['name'] ?? ''}',
      hallCapacity: asInt(hall['capacity']),
    );
  }
}

class ExamSeatingSheet {
  final int examScheduleId;
  final int totalSeated;
  final List<ExamSeatingModel> seatings;

  const ExamSeatingSheet({
    required this.examScheduleId,
    required this.totalSeated,
    required this.seatings,
  });

  const ExamSeatingSheet.empty(int scheduleId)
    : examScheduleId = scheduleId,
      totalSeated = 0,
      seatings = const [];

  factory ExamSeatingSheet.fromJson(Map<String, dynamic> json) {
    final raw = json['seatings'] is List ? json['seatings'] as List : const [];
    final seatings = raw
        .whereType<Map>()
        .map(
          (item) => ExamSeatingModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
    final total = json['total_seated'] is int
        ? json['total_seated'] as int
        : int.tryParse('${json['total_seated']}') ?? seatings.length;
    final scheduleId = json['exam_schedule_id'] is int
        ? json['exam_schedule_id'] as int
        : int.tryParse('${json['exam_schedule_id']}') ?? 0;

    return ExamSeatingSheet(
      examScheduleId: scheduleId,
      totalSeated: total,
      seatings: seatings,
    );
  }

  bool get hasSeatings => totalSeated > 0 || seatings.isNotEmpty;

  Map<int, List<ExamSeatingModel>> get byHall {
    final grouped = <int, List<ExamSeatingModel>>{};
    for (final seating in seatings) {
      grouped.putIfAbsent(seating.hallId, () => []).add(seating);
    }
    for (final entries in grouped.values) {
      entries.sort((a, b) => a.seatNumber.compareTo(b.seatNumber));
    }
    return grouped;
  }
}
