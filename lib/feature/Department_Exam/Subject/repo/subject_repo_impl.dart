import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_Exam/Subject/data/subject_model.dart';
import 'package:finalproject/feature/Department_Exam/Subject/repo/subject_repo.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final ApiService apiService; // افترضنا أنك تستخدم Dio أو مرسل طلبات مخصص

  SubjectRepositoryImpl(this.apiService);

  @override
  Future<SubjectResult> searchSubjects({
    required int yearId,
    int? specId,
    int page = 1,
  }) async {
    try {
      // 1. بناء البارامترات: نرسل filter للسنة دائماً
      final Map<String, dynamic> queryParams = {
        'filters[academic_year_id]': yearId.toString(),
        'page': page.toString(),
      };

      // 2. إذا كان هناك اختصاص (سنة 4 أو 5)، نضيفه للفلتر
      if (specId != null) {
        queryParams['filters[specialization_id]'] = specId.toString();
      }

      // 3. تنفيذ الطلب
      final response = await apiService.get(
        ApiEndpoints.specializationsobject,
        queryParameters: queryParams,
      );

      // 4. استخراج البيانات والـ Meta (للملفات التي أرسلتها)
      final List data = response.data['data'];
      final Map<String, dynamic> meta = response.data['meta'];

      // 5. تحويل الـ JSON إلى Models (بما فيها الـ nested objects)
      final List<SubjectModel> subjects = data
          .map((subjectJson) => SubjectModel.fromJson(subjectJson))
          .toList();

      return SubjectResult(
        subjects: subjects,
        total: meta['total'] ?? 0,
        currentPage: meta['current_page'] ?? 1,
        lastPage: meta['last_page'] ?? 1,
      );
    } catch (e) {
      // يفضل هنا استخدام Custom Exception ليعالج الـ Cubit الخطأ بشكل أفضل
      throw Exception("فشل جلب المواد: ${e.toString()}");
    }
  }
}
