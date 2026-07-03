class MatchingCampaignModel {
  final int id;
  final String title;
  final String type;
  final String status;
  final String startDate;
  final String endDate;

  MatchingCampaignModel({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  factory MatchingCampaignModel.fromJson(Map<String, dynamic> json) {
    return MatchingCampaignModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }

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
      default:
        return status.isEmpty ? 'غير محدد' : status;
    }
  }
}

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
