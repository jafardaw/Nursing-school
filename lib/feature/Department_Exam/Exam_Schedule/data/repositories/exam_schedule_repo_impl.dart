import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import '../model/exam_schedule_model.dart';
import 'exam_schedule_repo.dart';

// class ExamScheduleRepositoryImpl implements ExamScheduleRepository {
//   final ApiService _apiService;

//   ExamScheduleRepositoryImpl(this._apiService);

//   @override
//   Future<void> saveSchedule(List<ExamScheduleModel> schedules) async {
//     try {
//       final List<Map<String, dynamic>> data = schedules
//           .map((s) => s.toJson())
//           .toList();
//       final String jsonBody = jsonEncode(data);

//       print(
//         'ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss',
//       );

//       // 3. اطبع للتحققحقهىف
//       print('JSON Body: $jsonBody');
//       await _apiService.post(ApiEndpoints.examSchedules, jsonBody);
//     } catch (e) {
//       throw Exception('فشل حفظ برنامج الامتحانات: ${e.toString()}');
//     }
//   }
// }

class ExamScheduleRepositoryImpl implements ExamScheduleRepository {
  final ApiService _apiService;

  ExamScheduleRepositoryImpl(this._apiService);

  @override
  Future<void> saveSchedule(List<ExamScheduleModel> schedules) async {
    try {
      final List<Map<String, dynamic>> data = schedules
          .map((s) => s.toJson())
          .toList();

      // ✅ حول لـ JSON string
      final String jsonBody = jsonEncode(data);

      print('============ بيانات الإرسال ============');
      print('عدد الجلسات: ${data.length}');
      print('أول جلسة: ${data.first}');
      print('آخر جلسة: ${data.last}');
      print('========================================');

      await _apiService.post(ApiEndpoints.examSchedules, jsonBody);
    } on DioException catch (e) {
      // ✅ رسالة الخطأ من السيرفر
      print('============ خطأ من السيرفر ============');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('========================================');

      throw Exception(
        'فشل حفظ برنامج الامتحانات: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('فشل حفظ برنامج الامتحانات: ${e.toString()}');
    }
  }
}
