import 'package:finalproject/feature/auth/data/user_model.dart';

// ====== Base State ======
abstract class AuthState {
  const AuthState();
}

// ====== حالة البداية ======
class AuthInitial extends AuthState {
  const AuthInitial();
}

// ====== حالة التحميل ======
class AuthLoading extends AuthState {
  const AuthLoading();
}

// ====== حالة النجاح (المستخدم مسجل دخول) ======
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated({required this.user});
}

// ====== حالة غير مسجل دخول ======
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// ====== حالة خطأ ======
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});
}
