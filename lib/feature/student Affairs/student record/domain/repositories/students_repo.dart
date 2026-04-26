import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/student_model.dart';

abstract class StudentsRepo {
  Future<List<StudentModel>> getStudents({int page = 1, int perPage = 15});
  Future<StudentModel?> getStudentById(int id);
}