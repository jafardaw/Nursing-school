// الموديل الرئيسي الذي يجمع الطالب وعقوباته
class StudentPenaltiesModel {
  final StudentModel student;
  final List<PenaltyModel> penalties;
  final String academicYear; // الحقل المؤقت الذي طلبته

  StudentPenaltiesModel({
    required this.student,
    required this.penalties,
    this.academicYear = "2025 - 2026",
  });

  factory StudentPenaltiesModel.fromJson(Map<String, dynamic> json) {
    final studentData = StudentModel.fromJson(json['student'] ?? {});
    if (json['penalties'] != null && json['penalties'] is List) {
      return StudentPenaltiesModel(
        student: studentData,
        penalties: (json['penalties'] as List)
            .map(
              (e) =>
                  PenaltyModel.fromJson(e, studentName: studentData.fullName),
            )
            .toList(),
      );
    }
    // إذا كان العنصر سجل عقوبة منفرد من البحث
    final penalty = PenaltyModel.fromJson(json, studentName: studentData.fullName);
    return StudentPenaltiesModel(
      student: studentData,
      penalties: [penalty],
    );
  }
}

// موديل الطالب
class StudentModel {
  final int id;
  final String fullName;
  final String nationalnumber;
  final Academicyear? academicYear; // 👇 علامة استفهام لأنه يمكن ما يجي

  StudentModel({
    required this.id,
    required this.fullName,

    required this.nationalnumber,
    this.academicYear, // اختياري
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? 0,
      nationalnumber: json['national_number'] ?? 'غير معروف',
      fullName: json['full_name'] ?? 'غير معروف',
      academicYear: json['academic_year'] != null
          ? Academicyear.fromJson(json['academic_year'])
          : null, // إذا ما في، خليها null
    );
  }
}

// موديل العقوبة
class PenaltyModel {
  final int id;
  final String studentName;
  final String type;
  final String date;
  final String body;
  final EmployeeModel? employee;

  PenaltyModel({
    required this.id,
    required this.studentName,
    required this.type,
    required this.date,
    required this.body,
    this.employee,
  });

  factory PenaltyModel.fromJson(
    Map<String, dynamic> json, {
    String? studentName,
  }) {
    return PenaltyModel(
      id: json['id'] ?? 0,
      studentName: studentName ?? '',
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      body: json['body'] ?? '',
      employee: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'])
          : null,
    );
  }
}

// موديل الموظف
class EmployeeModel {
  final int id;
  final String fullName;

  EmployeeModel({required this.id, required this.fullName});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
    );
  }
}

class Academicyear {
  final int id;
  final String fullName;

  Academicyear({required this.id, required this.fullName});

  factory Academicyear.fromJson(Map<String, dynamic> json) {
    return Academicyear(
      id: json['id'] ?? 0,
      fullName: json['name'] ?? 'غير معروف',
    );
  }
}
