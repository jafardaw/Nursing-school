class SpecializationModel {
  final int id;
  final String name;
  final int durationYears;

  SpecializationModel({
    required this.id,
    required this.name,
    required this.durationYears,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      durationYears: json['duration_years'] ?? 0,
    );
  }
}

// كلاس مساعد للـ Pagination
class SpecializationResult {
  final List<SpecializationModel> specializations;
  final int total;
  SpecializationResult(this.specializations, this.total);
}
