import 'package:dio/dio.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1:8000/api/',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // إضافة headers الـ CORS
          options.headers['Access-Control-Allow-Origin'] = '*';
          options.headers['Access-Control-Allow-Methods'] =
              'GET, POST, PUT, DELETE, OPTIONS';
          options.headers['Access-Control-Allow-Headers'] =
              'Origin, Content-Type, X-Auth-Token, Authorization';
          // options.headers['Authorization'] =
          //     'Bearer ';

          try {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error getting token: $e');
            }
          }

          return handler.next(options);
        },

        // 🔑 مكان معالجة خطأ 401 وتجديد التوكن
        onError: (error, handler) async {
          final is401Error = error.response?.statusCode == 401;
          final isRefreshRequest = error.requestOptions.path == 'refresh';

          // 1. إذا كان الخطأ 401 ولم يكن طلب التجديد نفسه
          if (is401Error && !isRefreshRequest) {
            try {
              // 2. محاولة تجديد التوكن
              final response = await _dio.post('refresh');

              if (response.statusCode == 200 &&
                  response.data['status'] == "success") {
                final newToken = response.data['data']['token'];

                // تخزين التوكن الجديد
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', newToken);

                // 3. تحديث Header الطلب الأصلي الفاشل
                final originalRequest = error.requestOptions;
                originalRequest.headers['Authorization'] = 'Bearer $newToken';

                // 4. إعادة إرسال الطلب الأصلي (Re-send the failed request)
                final newResponse = await _dio.request(
                  originalRequest.path,
                  options: Options(
                    method: originalRequest.method,
                    headers: originalRequest.headers,
                  ),
                  data: originalRequest.data,
                  queryParameters: originalRequest.queryParameters,
                );

                // 5. إرجاع الرد الجديد بدلاً من الخطأ 401
                return handler.resolve(newResponse);
              }
            } catch (e) {
              // إذا فشل التجديد لسبب ما (خطأ في الشبكة، انتهاء صلاحية التوكن القديم، إلخ)
              if (kDebugMode) {
                print('Refresh attempt failed, forcing logout: $e');
              }
              // 6. إزالة التوكن وإجبار المستخدم على تسجيل الدخول مجدداً
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');

              // 7. تمرير الخطأ الأصلي ليتم التعامل معه في Cubit (غالباً رسالة خطأ أو توجيه لصفحة الدخول)
            }
          }

          // في حال فشل التجديد أو لم يكن الخطأ 401، نمرر الخطأ
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      // إضافة Log Interceptor لمرحلة التطوير فقط
      _dio.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> postwithOutData(String path) async {
    try {
      return await _dio.post(path);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> update(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> loginWithGoogle(String googleToken) async {
    try {
      return await _dio.post(
        'loginwithGoogel',
        data: {'googleToken': googleToken},
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
