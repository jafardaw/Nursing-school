class DormBuildingModel {
  final int id;
  final String name;
  final int totalFloors;
  final String? createdAt;
  final String? updatedAt;

  DormBuildingModel({
    required this.id,
    required this.name,
    required this.totalFloors,
    this.createdAt,
    this.updatedAt,
  });

  factory DormBuildingModel.fromJson(Map<String, dynamic> json) {
    return DormBuildingModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      totalFloors: json['total_floors'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_floors': totalFloors,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
