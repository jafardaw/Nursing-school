import 'package:finalproject/feature/engineering_office/data/model/complaint_model.dart';

abstract class ComplaintsRepo {
  Future<ComplaintsResponse> getComplaints({int page = 1, int perPage = 15});
  Future<ComplaintModel> forwardComplaint(int id, String approverRole);
}