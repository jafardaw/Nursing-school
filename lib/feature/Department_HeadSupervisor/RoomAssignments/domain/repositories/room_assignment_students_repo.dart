import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/students_response.dart';

abstract class RoomAssignmentStudentsRepository {
  Future<StudentsResponse> searchStudents({
    String? firstName,
    int page = 1,
    int perPage = 15,
  });
}
