class AddPenaltyModel {
  final int studentId;
  final int employeeId;
  final String type;
  final String date;
  final String body;

     AddPenaltyModel({
    required this.studentId,
    required this.employeeId,
    required this.type,
    required this.date,
    required this.body,
  });

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
    "employee_id": employeeId,
    "type": type,
    "date": date,
    "body": body,
  };
}
