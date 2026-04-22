abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException(super.message, [super.code]);
}

class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}

class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

class ValidationException extends AppException {
  final Map<String, String>? errors;

  const ValidationException(super.message, [this.errors, super.code]);
}

class AuthenticationException extends AppException {
  const AuthenticationException(super.message, [super.code]);
}

class AuthorizationException extends AppException {
  const AuthorizationException(super.message, [super.code]);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, [super.code]);
}

class TimeoutException extends AppException {
  const TimeoutException(super.message, [super.code]);
}

class UnknownException extends AppException {
  const UnknownException(super.message, [super.code]);
}
