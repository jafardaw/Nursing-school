import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/error_handler.dart';
import 'dart:developer' as developer;

typedef TokenRefreshCallback = Future<String?> Function();

class ApiClient {
  final Dio _dio;
  TokenRefreshCallback? _onTokenRefresh;
  bool _isRefreshing = false;

  ApiClient({
    required String baseUrl,
    Map<String, String>? headers,
    int? connectTimeout,
    int? receiveTimeout,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: Duration(
             milliseconds: connectTimeout ?? AppConstants.connectTimeout,
           ),
           receiveTimeout: Duration(
             milliseconds: receiveTimeout ?? AppConstants.receiveTimeout,
           ),
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
             ...?headers,
           },
         ),
       ) {
    _setupInterceptors();
  }

  /// ⚙️ تعيين callback لتجديد الـ Token تلقائياً عند انتهاء الصلاحية
  void setTokenRefreshCallback(TokenRefreshCallback callback) {
    _onTokenRefresh = callback;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> upload(
    String endpoint,
    FormData formData, {
    ProgressCallback? onSendProgress,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  void updateHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.options.headers['token'] = token;
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
    _dio.options.headers.remove('token');
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          developer.log('Dio Request: ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log('Dio Response: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) async {
          developer.log('Dio Error: ${error.message}');
          // 401: انتهت صلاحية Session Token
          if (error.response?.statusCode == 401 &&
              _onTokenRefresh != null &&
              !_isRefreshing) {
            _isRefreshing = true;
            try {
              final newToken = await _onTokenRefresh!();

              if (newToken != null && newToken.isNotEmpty) {
                setAuthToken(newToken);

                final options = error.requestOptions;
                options.headers['token'] = newToken;
                options.headers['Authorization'] = 'Bearer $newToken';

                final response = await _dio.request(
                  options.path,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                  data: options.data,
                  queryParameters: options.queryParameters,
                );

                _isRefreshing = false;
                developer.log('Dio Retried Response: ${response.data}');
                return handler.resolve(response);
              } else {
                _isRefreshing = false;
                handler.next(error);
              }
            } catch (e) {
              _isRefreshing = false;
              handler.next(error);
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }

  ErrorHandler _handleDioError(DioException error) {
    return ErrorHandler.handleDioError(error);
  }

  void dispose() {
    _dio.close();
  }
}
