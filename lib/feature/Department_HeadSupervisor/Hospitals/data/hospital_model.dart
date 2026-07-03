class HospitalModel {
  final int id;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  HospitalModel({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
