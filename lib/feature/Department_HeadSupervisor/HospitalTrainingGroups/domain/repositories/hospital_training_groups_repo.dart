import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/data/hospital_training_group_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Manager/data/models/employee_model.dart';

abstract class HospitalTrainingGroupsRepo {
  Future<HospitalTrainingGroupsResponse> getGroups({
    int page = 1,
    int? hospitalId,
    int? employeeId,
  });

  Future<void> createGroup(CreateHospitalTrainingGroupRequest request);

  Future<List<HospitalModel>> getHospitals();

  Future<List<EmployeeItem>> getEmployees();

  Future<List<StudentModeljd>> getStudents({String query = '', int page = 1});
}
