class HallModel {
  final int id;
  final String name;
  final int capacity;
  final String type;
  final String? createdAt;
  final String? updatedAt;

  HallModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      type: json['type'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
