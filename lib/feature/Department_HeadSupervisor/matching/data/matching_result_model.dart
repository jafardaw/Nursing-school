class MatchingResultModel {
  final int id;
  final String? gpaScore;
  final String submissionDate;
  final String status;
  final MatchedStudent? student;
  final MatchedSeatInfo? matchedSeat;

  MatchingResultModel({
    required this.id,
    this.gpaScore,
    required this.submissionDate,
    required this.status,
    this.student,
    this.matchedSeat,
  });

  factory MatchingResultModel.fromJson(Map<String, dynamic> json) {
    return MatchingResultModel(
      id: json['id'] ?? 0,
      gpaScore: json['gpa_score'],
      submissionDate: json['submission_date'] ?? '',
      status: json['status'] ?? '',
      student: json['student'] != null
          ? MatchedStudent.fromJson(json['student'])
          : null,
      matchedSeat: json['matched_seat'] != null
          ? MatchedSeatInfo.fromJson(json['matched_seat'])
          : null,
    );
  }

  bool get isMatched => status == 'Matched';
}

class MatchedStudent {
  final int id;
  final String firstName;
  final String lastName;

  MatchedStudent({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory MatchedStudent.fromJson(Map<String, dynamic> json) {
    return MatchedStudent(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}

class MatchedSeatInfo {
  final int id;
  final int capacity;
  final int matchedCount;
  final String? hospital;
  final String? specialization;

  MatchedSeatInfo({
    required this.id,
    required this.capacity,
    required this.matchedCount,
    this.hospital,
    this.specialization,
  });

  factory MatchedSeatInfo.fromJson(Map<String, dynamic> json) {
    return MatchedSeatInfo(
      id: json['id'] ?? 0,
      capacity: json['capacity'] ?? 0,
      matchedCount: json['matched_count'] ?? 0,
      hospital: json['hospital'],
      specialization: json['specialization'],
    );
  }

  String get displayName {
    if (hospital != null && specialization != null) {
      return '$hospital - $specialization';
    }
    return hospital ?? specialization ?? 'غير محدد';
  }
}
