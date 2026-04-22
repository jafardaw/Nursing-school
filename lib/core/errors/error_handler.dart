import 'package:dio/dio.dart';

class ErrorHandler implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ErrorHandler(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;

  static ErrorHandler handleDioError(DioException e) {
    String errorMessage = "حدث خطأ غير متوقع";
    int? statusCode;
    Map<String, dynamic>? errors;

    if (e.type == DioExceptionType.badResponse) {
      statusCode = e.response?.statusCode;
      errorMessage = extractErrorMessage(e.response);
      errors = extractErrors(e.response);
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = "انتهى وقت الاتصال بالخادم";
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = "انتهى وقت إرسال الطلب إلى الخادم";
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = "انتهى وقت استقبال الرد من الخادم";
          break;
        case DioExceptionType.badCertificate:
          errorMessage = "شهادة الأمان غير صالحة";
          break;
        case DioExceptionType.cancel:
          errorMessage = "تم إلغاء الطلب إلى الخادم";
          break;
        case DioExceptionType.connectionError:
          errorMessage = "خطأ في الاتصال بالخادم. تأكد من اتصالك بالإنترنت.";
          break;
        case DioExceptionType.unknown:
          errorMessage = "فشل الاتصال بالخادم أو مشكلة في الإنترنت.";
          break;
        default:
          errorMessage = "حدث خطأ غير متوقع.";
          break;
      }
    }

    return ErrorHandler(errorMessage, statusCode: statusCode, errors: errors);
  }

  static String extractErrorMessage(Response? response) {
    if (response != null && response.data is Map) {
      var responseData = response.data;
      String message = responseData['message'] ?? "حدث خطأ غير متوقع";

      // إذا كان فيه code نستخدمه في الـ status code
      if (responseData['code'] != null) {
        // message كافي لأن ما في errors array
        return message;
      }

      return message;
    }
    return "حدث خطأ دون معلومات إضافية";
  }

  static Map<String, dynamic>? extractErrors(Response? response) {
    if (response != null && response.data is Map) {
      var responseData = response.data;

      // إذا كان فيه errors array (للحالات القديمة)
      if (responseData.containsKey('errors')) {
        return responseData['errors'] as Map<String, dynamic>?;
      }

      // إذا ما في errors array، نرجع null لأن الرسالة كافية
      return null;
    }
    return null;
  }

  // Helper methods للـ status codes
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422 || statusCode == 400;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isNetworkError => statusCode == null;

  // دالة ترجع الرسالة الجاهزة
  String get userFriendlyMessage {
    if (isUnauthorized) {
      return message; // الرسالة جاهزة من API
    } else if (isValidationError && errors != null) {
      // إذا كان فيه errors array (حالات قديمة)
      final firstError = errors!.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first;
      }
      return message;
    } else if (isValidationError) {
      // حالة 422 بدون errors array - نرجع الرسالة من API
      return message;
    } else if (isNetworkError) {
      return 'مشكلة في الاتصال بالإنترنت';
    } else if (isServerError) {
      return 'مشكلة في الخادم، يرجى المحاولة لاحقاً';
    } else if (isNotFound) {
      return 'الخدمة غير متوفرة حالياً';
    } else if (isForbidden) {
      return 'ليس لديك صلاحية للوصول لهذه الخدمة';
    } else {
      return message; // نرجع الرسالة من API مباشرة
    }
  }
}
