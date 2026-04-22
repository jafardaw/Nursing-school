import 'dart:async';

/// Global stream للـ auth changes
/// يستخدم GoRouter للـ redirect تلقائي عند logout
class AuthEventStream {
  static final AuthEventStream _instance = AuthEventStream._();
  
  factory AuthEventStream() => _instance;
  AuthEventStream._();

  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  
  /// true = logged out, false = logged in
  Stream<bool> get authChanges => _controller.stream;

  /// استدعِ عند logout
  void logOut() {
    _controller.add(true);
  }

  /// استدعِ عند login
  void logIn() {
    _controller.add(false);
  }

  void dispose() {
    _controller.close();
  }
}

final authEventStream = AuthEventStream();