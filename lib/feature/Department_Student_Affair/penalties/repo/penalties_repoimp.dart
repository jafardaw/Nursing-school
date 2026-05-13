import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/data/addpenaltymodel.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/data/penalties_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repo.dart';

class AbsenceRepositoryImpl implements AbsenceRepository {
  final ApiService _apiService;

  AbsenceRepositoryImpl(this._apiService);

  // penalties_repo_impl.dart
  // penalties_repo_impl.dart
  @override
  Future<PenaltyResult> getAbsences({int page = 1}) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.penalties,
        queryParameters: {'page': page},
      );

      final List data = response.data['data'];
      final int total = response.data['meta']['total'];

      // نستخدم الموديل الجديد مباشرة هنا
      final List<StudentPenaltiesModel> absences = data
          .map((json) => StudentPenaltiesModel.fromJson(json))
          .toList();

      return PenaltyResult(absences, total);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PenaltyResult> getAbsencesSearch(String name, String year) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.penaltiesSearch,
        data: {"column": "student_name", "value": "رهف"},
      );
      print("response.data");
      print(response.data);
      final List data = response.data['data'];
      final int total = response.data['meta']['total'];

      // نستخدم الموديل الجديد مباشرة هنا
      final List<StudentPenaltiesModel> absences = data
          .map((json) => StudentPenaltiesModel.fromJson(json))
          .toList();

      return PenaltyResult(absences, total);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addPenalty(AddPenaltyModel penalty) async {
    try {
      // إرسال الـ Body الذي حددناه للسيرفر
      await _apiService.post(ApiEndpoints.penalties, penalty.toJson());
    } catch (e) {
      // الـ ApiService سيتكفل برمي الخطأ والـ Cubit سيمسكه
      rethrow;
    }
  }

  @override
  Future<String> deletePenalty(int id) async {
    try {
      await _apiService.delete(ApiEndpoints.penaltiesid(id));
      return "تم حذف السجل بنجاح";
    } catch (e) {
      // نرفع الخطأ كما هو ليمسكه الكيوبيت
      throw Exception("فشل الحذف: ${e.toString()}");
    }
  }
}
