import 'dart:typed_data';

import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/create_student_request.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/students_response.dart';

abstract class StudentsRepo {
  Future<StudentsResponse> getStudents({
    int page = 1,
    int perPage = 15,
  }); // 🟢 تغير

  Future<void> createStudent(CreateStudentRequest request);
 Future<Uint8List> exportStudentsPdf();
   Future<void> updateStudent(int id, CreateStudentRequest request); // 🟢 جديد

}
