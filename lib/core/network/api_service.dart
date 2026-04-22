import 'package:finalproject/core/network/api_client.dart';
import 'package:finalproject/core/security/encryption_service.dart';
import 'package:finalproject/core/services/auth_event_stream.dart';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../constants/api_endpoints.dart';
import '../storage/storage_service.dart';
import '../errors/error_handler.dart';
import 'dart:developer' as developer;

class ApiService {
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();

  ApiService._();

  late final ApiClient _apiClient;
  late final StorageService _storage;
  late final EncryptionService _encryptionService;

  // Initialize the service
  Future<void> initialize({
    required String baseUrl,
    Map<String, String>? defaultHeaders,
    StorageService? storage,
  }) async {
    _storage = storage ?? await StorageServiceImpl.create();
    _encryptionService = await EncryptionService.create();

    _apiClient = ApiClient(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?defaultHeaders,
      },
    );

    // ⚙️ تعيين callback للـ token refresh التلقائي
    _apiClient.setTokenRefreshCallback(_refreshTokenCallback);

    // 🔐 تحديث الـ Token من التخزين إن وُجد
    await _setAuthTokenFromStorage();
  }

  /// 🔄 Callback لتجديد الـ Token عند استقبال 401
  /// Phase C: يتم استدعاؤه تلقائياً عند انتهاء صلاحية الـ Session Token
  Future<String?> _refreshTokenCallback() async {
    try {
      final refreshToken = await _storage.getString(
        AppConstants.refreshTokenKey,
      );
      final uuid = await _storage.getString(AppConstants.userUuidKey);

      if (refreshToken == null ||
          refreshToken.isEmpty ||
          uuid == null ||
          uuid.isEmpty) {
        await _clearSessionData();
        return null;
      }

      final response = await _apiClient.post(
        ApiEndpoints.refreshSession,
        data: {
          AppConstants.uuidKey: uuid,
          AppConstants.refreshTokenKey: refreshToken,
        },
      );

      final dataList = response['data'] as List?;
      final first = (dataList != null && dataList.isNotEmpty)
          ? dataList.first as Map<String, dynamic>
          : null;

      final newSessionToken = first?['token']?.toString();
      developer.log('Token Refresh Response: $response');

      developer.log('Extracted New Session Token: $newSessionToken');
      if (newSessionToken == null || newSessionToken.isEmpty) {
        await _clearSessionData();
        return null;
      }

      await setAuthToken(newSessionToken, uuid);

      final expiresAt = first?['expires_at']?.toString();
      if (expiresAt != null && expiresAt.isNotEmpty) {
        await _storage.saveString(AppConstants.tokenExpiresAtKey, expiresAt);
      }

      return newSessionToken;
    } catch (_) {
      await _clearSessionData();
      return null;
    }
  }

  Future<void> _clearSessionData() async {
    await _storage.remove(AppConstants.tokenKey);
    await _storage.remove(AppConstants.refreshTokenKey);
    await _storage.remove(AppConstants.tokenExpiresAtKey);

    await _storage.remove(AppConstants.userUuidKey);
    await _storage.remove(AppConstants.userDataKey);
    _apiClient.clearAuthToken();

    authEventStream.logOut();
  }

  /// 🔐 دالة محسّنة لتعيين الـ Token
  /// تحفظ كل من Session Token و UUID
  Future<void> setAuthToken(String token, [String? uuid]) async {
    final encryptedToken = _encryptionService.encryptToken(token);
    await _storage.saveString(AppConstants.tokenKey, encryptedToken);

    if (uuid != null) {
      await _storage.saveString(AppConstants.userUuidKey, uuid);
    }
    _apiClient.setAuthToken(token);
  }

  Future<void> _setAuthTokenFromStorage() async {
    final encryptedToken = await _storage.getString(AppConstants.tokenKey);
    if (encryptedToken == null || encryptedToken.isEmpty) {
      return;
    }

    try {
      final rawToken = _encryptionService.decryptToken(encryptedToken);
      _apiClient.setAuthToken(rawToken);
    } catch (e) {
      await clearAuthToken();
      return;
    }
  }

  // Clear auth token
  Future<void> clearAuthToken() async {
    await _storage.remove(AppConstants.tokenKey);
    _apiClient.clearAuthToken();
  }

  // Get current token
  Future<String?> getAuthToken() async {
    final encryptedToken = await _storage.getString(AppConstants.tokenKey);
    if (encryptedToken == null || encryptedToken.isEmpty) {
      return null;
    }

    try {
      return _encryptionService.decryptToken(encryptedToken);
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // HTTP Methods
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await _checkAuth();
    return _apiClient.get(
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await _checkAuth();
    return _apiClient.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await _checkAuth();
    return _apiClient.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await _checkAuth();
    return _apiClient.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dynamic> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await _checkAuth();
    return _apiClient.patch(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // File upload
  Future<dynamic> upload(
    String endpoint,
    FormData formData, {
    ProgressCallback? onSendProgress,
    Options? options,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await _checkAuth();
    return _apiClient.upload(
      endpoint,
      formData,
      onSendProgress: onSendProgress,
      options: options,
    );
  }

  // File download
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await _checkAuth();
    return _apiClient.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      options: options,
    );
  }

  void updateHeaders(Map<String, String> headers) {
    _apiClient.updateHeaders(headers);
  }

  // Check authentication status
  Future<void> _checkAuth() async {
    if (!await isAuthenticated()) {
      throw ErrorHandler('User not authenticated', statusCode: 401);
    }
  }

  // Dispose
  void dispose() {
    _apiClient.dispose();
  }
}
