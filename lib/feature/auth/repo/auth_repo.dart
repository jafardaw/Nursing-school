import 'package:finalproject/feature/auth/data/user_model.dart';

abstract class AuthRepo {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel?> getSavedUser();

  Future<bool> isLoggedIn();
}