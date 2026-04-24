import 'package:dio/dio.dart';
import 'package:finalproject/core/constants/app_constants.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/core/utils/logger.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio;
  final StorageService _storage;

  ApiService({required StorageService storageService})
    : _storage = storageService,
      _dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrlPublic,
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
          // 🟢 جلب التوكن من StorageService
          try {
            final token = await _storage.getString(AppConstants.tokenKey);
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
              Logger.debug('Token attached to request: ${options.path}');
            }
          } catch (e) {
            if (kDebugMode) {
              Logger.info('No token found for request: ${options.path}');
            }
          }

          return handler.next(options);
        },

        onError: (error, handler) async {
          Logger.error('API Error: ${error.requestOptions.path}', error: error);
          // 🟢 معالجة خطأ 401
          if (error.response?.statusCode == 401) {
            Logger.warning('Token expired, clearing auth data');
            await _storage.remove(AppConstants.tokenKey);
            await _storage.remove(AppConstants.userKey);

            if (kDebugMode) {
              print('Token expired, user needs to login again');
            }
          }

          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          logPrint: (object) => Logger.debug(object.toString(), tag: 'Dio'),
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }
  }

  // ====== HTTP Methods ======

// ====== HTTP Methods ======

Future<Response> post(String path, dynamic data, {Map<String, dynamic>? queryParameters}) async {
  try {
    Logger.info('POST $path', tag: 'API');
    Logger.debug('Data: $data', tag: 'API');
    
    final response = await _dio.post(path, data: data, queryParameters: queryParameters);
    
    Logger.info('POST $path - Success (${response.statusCode})', tag: 'API');
    return response;
  } on DioException catch (e) {
    Logger.error('POST $path failed', error: e);
    throw ErrorHandler.handleDioError(e);
  }
}

Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
  try {
    Logger.info('GET $path', tag: 'API');
    
    final response = await _dio.get(path, queryParameters: queryParameters);
    
    Logger.info('GET $path - Success (${response.statusCode})', tag: 'API');
    return response;
  } on DioException catch (e) {
    Logger.error('GET $path failed', error: e);
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

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
