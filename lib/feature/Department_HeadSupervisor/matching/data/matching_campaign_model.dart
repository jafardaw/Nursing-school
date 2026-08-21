class MatchingCampaignModel {
  final int id;
  final String title;
  final String type;
  final String status;
  final String startDate;
  final String endDate;
  final List<MatchingSeat> seats;

  MatchingCampaignModel({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.seats = const [],
  });

  factory MatchingCampaignModel.fromJson(Map<String, dynamic> json) {
    final seatsJson = json['seats'] as List<dynamic>? ?? [];
    return MatchingCampaignModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      seats: seatsJson.map((s) => MatchingSeat.fromJson(s)).toList(),
    );
  }

  bool get hasSeats => seats.isNotEmpty;

  int get totalCapacity =>
      seats.fold(0, (sum, s) => sum + s.capacity);

  int get totalMatched =>
      seats.fold(0, (sum, s) => sum + s.matchedCount);

  int get totalRemaining =>
      seats.fold(0, (sum, s) => sum + s.remaining);

  String get typeLabel {
    switch (type) {
      case 'Specialization':
        return 'اختصاص فقط';
      case 'General_Hospital':
        return 'مشافي';
      default:
        return type.isEmpty ? 'غير محدد' : type;
    }
  }

  String get statusLabel {
    switch (status) {
      case 'Active':
        return 'نشط';
      case 'Draft':
        return 'مسودة';
      case 'Completed':
        return 'مكتمل';
      default:
        return status.isEmpty ? 'غير محدد' : status;
    }
  }
}

/// مقعد مفاضلة (بيانات القراءة من الـ API)
class MatchingSeat {
  final int id;
  final int capacity;
  final int matchedCount;
  final int remaining;
  final String? hospitalName;
  final int? hospitalId;
  final String? specializationName;
  final int? specializationId;

  MatchingSeat({
    required this.id,
    required this.capacity,
    required this.matchedCount,
    required this.remaining,
    this.hospitalName,
    this.hospitalId,
    this.specializationName,
    this.specializationId,
  });

  factory MatchingSeat.fromJson(Map<String, dynamic> json) {
    final hospital = json['hospital'] as Map<String, dynamic>?;
    final specialization = json['specialization'] as Map<String, dynamic>?;
    return MatchingSeat(
      id: json['id'] ?? 0,
      capacity: json['capacity'] ?? 0,
      matchedCount: json['matched_count'] ?? 0,
      remaining: json['remaining'] ?? 0,
      hospitalName: hospital?['name'],
      hospitalId: hospital?['id'],
      specializationName: specialization?['name'],
      specializationId: specialization?['id'],
    );
  }

  /// الاسم المعروض في الجدول
  String get displayName {
    if (hospitalName != null && specializationName != null) {
      return '$hospitalName - $specializationName';
    }
    return hospitalName ?? specializationName ?? 'غير محدد';
  }
}

/// مقعد مفاضلة (بيانات الإرسال للـ API)
class MatchingSeatInput {
  final int? hospitalId;
  final int? specializationId;
  final int capacity;

  MatchingSeatInput({
    required this.hospitalId,
    required this.specializationId,
    required this.capacity,
  });

  Map<String, dynamic> toJson() {
    return {
      'hospital_id': hospitalId,
      'specialization_id': specializationId,
      'capacity': capacity,
    };
  }
}
