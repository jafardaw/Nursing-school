import 'package:finalproject/feature/auth/presentation/manger/auth_state.dart';
import 'package:finalproject/feature/auth/repo/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/errors/error_handler.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepoImpl _authRepo;

  AuthCubit(this._authRepo) : super(const AuthInitial());

  // ====== التحقق من حالة تسجيل الدخول عند بدء التطبيق ======
  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _authRepo.isLoggedIn();

    if (isLoggedIn) {
      final user = await _authRepo.getSavedUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  // ====== تسجيل الدخول ======
  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepo.login(email: email, password: password);
      emit(AuthAuthenticated(user: user));
    } on ErrorHandler catch (e) {
      emit(AuthError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  // ====== تسجيل الخروج ======
  Future<void> logout() async {
    await _authRepo.logout();
    emit(const AuthUnauthenticated());
  }

  // ====== مسح الخطأ ======
  void clearError() {
    emit(const AuthInitial());
  }
}
