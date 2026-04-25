import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/constants/app_constants.dart';
import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/core/utils/logger.dart';

import 'package:finalproject/feature/auth/data/user_model.dart';
import 'package:finalproject/feature/auth/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService _apiService;
  final StorageService _storage;

  AuthRepoImpl({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storage = storageService;
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    Logger.info('Attempting login for: $email', tag: 'Auth');

    try {
      final response = await _apiService.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      Logger.info('Response data: ${response.data}', tag: 'Auth');

      // 🟢 استخدام fromFullJson عشان نجيب baseResponse + user
      final userModel = UserModel.fromFullJson(response.data);

      if (userModel.baseResponse.isSuccess) {
        // حفظ التوكن والبيانات
        if (userModel.token != null) {
          await _storage.saveString(AppConstants.tokenKey, userModel.token!);
        }

        await _storage.saveObject(
          AppConstants.userKey,
          response.data['data']['user'],
        );

        Logger.info(
          'Login successful - Status: ${userModel.baseResponse.status}, Message: ${userModel.baseResponse.message}',
          tag: 'Auth',
        );
      } else {
        Logger.warning(
          'Login failed - Status: ${userModel.baseResponse.status}, Message: ${userModel.baseResponse.message}',
          tag: 'Auth',
        );
      }

      return userModel;
    } catch (e) {
      Logger.error('Login failed for: $email', error: e, tag: 'Auth');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // ممكن نضيف API call لو فيه logout endpoint
    try {
      await _apiService.post(ApiEndpoints.logout, null);
    } catch (_) {
      // حتى لو فشل الـ API call، نمسح البيانات المحلية
    }

    await _storage.remove(AppConstants.tokenKey);
    await _storage.remove(AppConstants.userKey);
  }

  @override
  Future<UserModel?> getSavedUser() async {
    final userData = await _storage.getObject(AppConstants.userKey);
    final token = await _storage.getString(AppConstants.tokenKey);

    if (userData != null) {
      return UserModel.fromFullJson(userData).copyWith(token: token);
    }
    return null;
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _storage.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }
}

// ====== CopyWith Extension ======
extension UserModelCopyWith on UserModel {
  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    List<String>? permissions,
    String? token,
    BaseResponse? baseResponse,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      token: token ?? this.token,
      baseResponse: baseResponse ?? this.baseResponse,
    );
  }
}
