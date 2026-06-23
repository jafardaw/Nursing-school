// Models for Manager Dashboard Feature

// ==================== 1. General Dashboard Stats Models ====================

class ManagerDashboardStats {
  final ManagerStudentsOverview students;
  final ManagerEmployeesOverview employees;
  final ManagerWarehouseOverview warehouse;

  ManagerDashboardStats({
    required this.students,
    required this.employees,
    required this.warehouse,
  });

  factory ManagerDashboardStats.fromJson(Map<String, dynamic> json) {
    return ManagerDashboardStats(
      students: ManagerStudentsOverview.fromJson(json['students'] ?? {}),
      employees: ManagerEmployeesOverview.fromJson(json['employees'] ?? {}),
      warehouse: ManagerWarehouseOverview.fromJson(json['warehouse'] ?? {}),
    );
  }
}

class ManagerStudentsOverview {
  final int total;
  final int active;
  final int graduated;

  ManagerStudentsOverview({
    required this.total,
    required this.active,
    required this.graduated,
  });

  factory ManagerStudentsOverview.fromJson(Map<String, dynamic> json) {
    return ManagerStudentsOverview(
      total: json['total'] as int? ?? 0,
      active: json['active'] as int? ?? 0,
      graduated: json['graduated'] as int? ?? 0,
    );
  }
}

class ManagerEmployeesOverview {
  final int total;
  final List<ManagerDepartmentStats> departments;

  ManagerEmployeesOverview({
    required this.total,
    required this.departments,
  });

  factory ManagerEmployeesOverview.fromJson(Map<String, dynamic> json) {
    final list = json['departments'] as List? ?? [];
    return ManagerEmployeesOverview(
      total: json['total'] as int? ?? 0,
      departments: list.map((item) => ManagerDepartmentStats.fromJson(item)).toList(),
    );
  }
}

class ManagerDepartmentStats {
  final String department;
  final int count;
  final String? jobTitle;
  final String? user;

  ManagerDepartmentStats({
    required this.department,
    required this.count,
    this.jobTitle,
    this.user,
  });

  factory ManagerDepartmentStats.fromJson(Map<String, dynamic> json) {
    return ManagerDepartmentStats(
      department: json['department'] as String? ?? 'Unknown',
      count: json['count'] as int? ?? 0,
      jobTitle: json['job_title'] as String?,
      user: json['user'] as String?,
    );
  }
}

class ManagerWarehouseOverview {
  final int totalItems;
  final int lowStockItems;

  ManagerWarehouseOverview({
    required this.totalItems,
    required this.lowStockItems,
  });

  factory ManagerWarehouseOverview.fromJson(Map<String, dynamic> json) {
    return ManagerWarehouseOverview(
      totalItems: json['total_items'] as int? ?? 0,
      lowStockItems: json['low_stock_items'] as int? ?? 0,
    );
  }
}


// ==================== 2. Student Statistics Models ====================

class StudentStats {
  final StudentStatsOverview overview;
  final List<StudentYearDistributionItem> distributionByYear;

  StudentStats({
    required this.overview,
    required this.distributionByYear,
  });

  factory StudentStats.fromJson(Map<String, dynamic> json) {
    final list = json['distribution_by_year'] as List? ?? [];
    return StudentStats(
      overview: StudentStatsOverview.fromJson(json['overview'] ?? {}),
      distributionByYear: list.map((item) => StudentYearDistributionItem.fromJson(item)).toList(),
    );
  }
}

class StudentStatsOverview {
  final StudentStatsOverviewItem registeredStudents;
  final StudentStatsOverviewItem graduatedStudents;
  final StudentStatsOverviewItem absenceWarnings;

  StudentStatsOverview({
    required this.registeredStudents,
    required this.graduatedStudents,
    required this.absenceWarnings,
  });

  factory StudentStatsOverview.fromJson(Map<String, dynamic> json) {
    return StudentStatsOverview(
      registeredStudents: StudentStatsOverviewItem.fromJson(
        json['registered_students'] ?? {},
        defaultLabel: 'إجمالي الطالبات المسجلات',
      ),
      graduatedStudents: StudentStatsOverviewItem.fromJson(
        json['graduated_students'] ?? {},
        defaultLabel: 'الطالبات الخريجات',
      ),
      absenceWarnings: StudentStatsOverviewItem.fromJson(
        json['absence_warnings'] ?? {},
        defaultLabel: 'إنذارات الغياب',
      ),
    );
  }
}

class StudentStatsOverviewItem {
  final int total;
  final String label;
  final String subLabel;
  final String type;

  StudentStatsOverviewItem({
    required this.total,
    required this.label,
    required this.subLabel,
    required this.type,
  });

  factory StudentStatsOverviewItem.fromJson(Map<String, dynamic> json, {required String defaultLabel}) {
    return StudentStatsOverviewItem(
      total: json['total'] as int? ?? 0,
      label: json['label'] as String? ?? defaultLabel,
      subLabel: json['sub_label'] as String? ?? '',
      type: json['type'] as String? ?? 'info',
    );
  }
}

class StudentYearDistributionItem {
  final String name;
  final int count;

  StudentYearDistributionItem({
    required this.name,
    required this.count,
  });

  factory StudentYearDistributionItem.fromJson(Map<String, dynamic> json) {
    return StudentYearDistributionItem(
      name: json['name'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}


// ==================== 3. Warehouse Report Models ====================

class WarehouseStats {
  final int totalItems;
  final int totalStockQuantity;
  final int availableItems;
  final int outOfStockItems;
  final int lowStockItems;
  final List<WarehouseItem> topStockedItems;

  WarehouseStats({
    required this.totalItems,
    required this.totalStockQuantity,
    required this.availableItems,
    required this.outOfStockItems,
    required this.lowStockItems,
    required this.topStockedItems,
  });

  factory WarehouseStats.fromJson(Map<String, dynamic> json) {
    final list = json['top_stocked_items'] as List? ?? [];
    return WarehouseStats(
      totalItems: json['total_items'] as int? ?? 0,
      totalStockQuantity: json['total_stock_quantity'] as int? ?? 0,
      availableItems: json['available_items'] as int? ?? 0,
      outOfStockItems: json['out_of_stock_items'] as int? ?? 0,
      lowStockItems: json['low_stock_items'] as int? ?? 0,
      topStockedItems: list.map((item) => WarehouseItem.fromJson(item)).toList(),
    );
  }
}

class WarehouseItem {
  final int id;
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;
  final int totalQuantity;
  final bool isLowStock;
  final String createdAt;
  final String updatedAt;

  WarehouseItem({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.minStockAlert,
    required this.totalQuantity,
    required this.isLowStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WarehouseItem.fromJson(Map<String, dynamic> json) {
    return WarehouseItem(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'N/A',
      description: json['description'] as String? ?? '',
      unit: json['unit'] as String? ?? 'Piece',
      minStockAlert: json['min_stock_alert'] as int? ?? 0,
      totalQuantity: json['total_quantity'] as int? ?? 0,
      isLowStock: json['is_low_stock'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}
