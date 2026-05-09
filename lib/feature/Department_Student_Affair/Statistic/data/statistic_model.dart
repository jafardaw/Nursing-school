class StatisticsModel {
  final Overview overview;
  final List<DistributionItem> distributionByYear;

  StatisticsModel({required this.overview, required this.distributionByYear});

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      overview: Overview.fromJson(json['overview']),
      distributionByYear: (json['distribution_by_year'] as List)
          .map((i) => DistributionItem.fromJson(i))
          .toList(),
    );
  }
}

class Overview {
  final StatItem registeredStudents;
  final StatItem graduatedStudents;
  final StatItem absenceWarnings;

  Overview({
    required this.registeredStudents,
    required this.graduatedStudents,
    required this.absenceWarnings,
  });

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      registeredStudents: StatItem.fromJson(json['registered_students'] ?? {}),
      graduatedStudents: StatItem.fromJson(json['graduated_students'] ?? {}),
      absenceWarnings: StatItem.fromJson(json['absence_warnings'] ?? {}),
    );
  }
}

class StatItem {
  final int total;
  final String label;
  final String subLabel;
  final String type;

  StatItem({
    required this.total,
    required this.label,
    required this.subLabel,
    required this.type,
  });

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      total: json['total'] ?? 0,
      label: json['label'] ?? '',
      subLabel: json['sub_label'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class DistributionItem {
  final String name;
  final int count;

  DistributionItem({required this.name, required this.count});

  factory DistributionItem.fromJson(Map<String, dynamic> json) {
    return DistributionItem(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
