import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';

import '../model/exam_schedule_model.dart';
import 'exam_schedule_repo.dart';

class ExamScheduleRepositoryImpl implements ExamScheduleRepository {
  final ApiService _apiService;

  ExamScheduleRepositoryImpl(this._apiService);

  @override
  Future<void> saveSchedule(List<ExamScheduleModel> schedules) async {
    try {
      final data = schedules.map((schedule) => schedule.toJson()).toList();
      await _apiService.post(ApiEndpoints.examSchedules, jsonEncode(data));
    } on DioException catch (error) {
      throw Exception(
        'فشل حفظ البر؆امج الامتحاني: ${error.response?.data ?? error.message}',
      );
    }
  }

  @override
  Future<List<ExamScheduleModel>> getSchedules({int? examSessionId}) async {
    if (examSessionId == null) {
      throw ArgumentError(
        'ÙŠØ¬Ø¨ ØªØ­Ø¯ÙŠØ¯ Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ø¯ÙˆØ±Ø© Ø§Ù„Ø§Ù…ØªØ­Ø§Ù†ÙŠØ© Ù„Ø¬Ù„Ø¨ Ø¨Ø±Ù†Ø§Ù…Ø¬Ù‡Ø§.',
      );
    }

    final response = await _apiService.get(
      ApiEndpoints.examSessionSchedulesWithCount(examSessionId),
    );

    final payload = response.data;
    final data = payload is Map<String, dynamic> ? payload['data'] : payload;
    final records = data is List ? data : const [];
    final schedules = records
        .whereType<Map>()
        .map(
          (record) =>
              ExamScheduleModel.fromJson(Map<String, dynamic>.from(record)),
        )
        .toList();

    return schedules;
  }

  @override
  Future<void> updateSchedules(List<ExamScheduleModel> schedules) async {
    final updates = schedules
        .where((schedule) => schedule.id != null)
        .map((schedule) => schedule.toUpdateJson())
        .toList();

    if (updates.isEmpty) return;
    await _apiService.put(ApiEndpoints.examSchedules, updates);
  }

  @override
  Future<void> deleteSchedules(List<int> ids) async {
    if (ids.isEmpty) return;
    await _apiService.delete(ApiEndpoints.examSchedules, data: {'ids': ids});
  }
}
