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
  Future<PenaltyResult> getAbsencesSearch({
    String? name,
    String? yearId,
    int page = 1,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'page': page};
      if (yearId != null &&
          yearId.isNotEmpty &&
          yearId != 'الكل' &&
          yearId != '0') {
        queryParams['filters[academic_year_id]'] = yearId;
      }
      if (name != null && name.trim().isNotEmpty) {
        queryParams['filters[full_name]'] = name.trim();
      }

      final response = await _apiService.get(
        ApiEndpoints.penaltiesSearch,
        queryParameters: queryParams,
      );

      final List data =
          response.data['data'] is List ? response.data['data'] : [];
      final int total =
          response.data['meta']?['total'] ??
          (response.data['total'] ?? data.length);

      final Map<int, StudentPenaltiesModel> studentMap = {};

      for (var json in data) {
        final parsed = StudentPenaltiesModel.fromJson(json);
        final studentId = parsed.student.id;

        if (studentMap.containsKey(studentId)) {
          studentMap[studentId]!.penalties.addAll(parsed.penalties);
        } else {
          studentMap[studentId] = StudentPenaltiesModel(
            student: parsed.student,
            penalties: List.from(parsed.penalties),
            academicYear: parsed.academicYear,
          );
        }
      }

      final List<StudentPenaltiesModel> absences = studentMap.values.toList();

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
  Future<void> updatePenalty({
    required int penaltyId,
    required String type,
    required String date,
    required String body,
  }) async {
    await _apiService.put(ApiEndpoints.penaltiesid(penaltyId), {
      'type': type,
      'date': date,
      'body': body,
    });
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
