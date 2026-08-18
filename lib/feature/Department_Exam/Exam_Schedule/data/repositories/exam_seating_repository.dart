import 'package:dio/dio.dart';
import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';

import '../model/exam_seating_model.dart';

abstract class ExamSeatingRepository {
  Future<ExamSeatingSheet> getSeatings(int scheduleId);

  Future<void> allocateSeats({
    required int scheduleId,
    required List<int> hallIds,
  });
}

class ExamSeatingRepositoryImpl implements ExamSeatingRepository {
  final ApiService _apiService;

  ExamSeatingRepositoryImpl(this._apiService);

  @override
  Future<ExamSeatingSheet> getSeatings(int scheduleId) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.examScheduleSeatings(scheduleId),
      );
      final raw = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : const <String, dynamic>{};
      final data = raw['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(raw['data'] as Map)
          : const <String, dynamic>{};
      return ExamSeatingSheet.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return ExamSeatingSheet.empty(scheduleId);
      }
      throw Exception(
        error.response?.data?['message']?.toString() ??
            'تعذر جلب ورقة المقاعد.',
      );
    } catch (error) {
      throw Exception('تعذر جلب ورقة المقاعد: $error');
    }
  }

  @override
  Future<void> allocateSeats({
    required int scheduleId,
    required List<int> hallIds,
  }) async {
    try {
      await _apiService.post(
        ApiEndpoints.examScheduleAllocateSeats(scheduleId),
        {'hall_ids': hallIds},
      );
    } on DioException catch (error) {
      throw Exception(
        error.response?.data?['message']?.toString() ??
            'تعذر تنفيذ التوزيع التلقائي للمقاعد.',
      );
    } catch (error) {
      throw Exception('تعذر تنفيذ التوزيع التلقائي: $error');
    }
  }
}
