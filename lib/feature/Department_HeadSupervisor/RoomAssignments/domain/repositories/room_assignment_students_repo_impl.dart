import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/students_response.dart';

import 'room_assignment_students_repo.dart';

class RoomAssignmentStudentsRepositoryImpl
    implements RoomAssignmentStudentsRepository {
  final ApiService apiService;

  RoomAssignmentStudentsRepositoryImpl(this.apiService);

  @override
  Future<StudentsResponse> searchStudents({
    String? firstName,
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (firstName != null && firstName.trim().isNotEmpty) {
      queryParameters['filters[first_name]'] = firstName.trim();
    }

    final response = await apiService.get(
      ApiEndpoints.studentsSearch,
      queryParameters: queryParameters,
    );

    return StudentsResponse.fromJson(response.data);
  }
}
