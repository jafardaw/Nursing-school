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
      final responseData = response.data;

      // 🟢 نقرأ الـ message مباشرة (للحالتين success و error)
      if (responseData['message'] != null) {
        return responseData['message'].toString();
      }
    }
    return "حدث خطأ دون معلومات إضافية";
  }

  static Map<String, dynamic>? extractErrors(Response? response) {
    if (response != null && response.data is Map) {
      final responseData = response.data;

      // 🟢 إذا كان فيه errors object (حالات validation)
      if (responseData.containsKey('errors') && responseData['errors'] is Map) {
        return responseData['errors'] as Map<String, dynamic>;
      }
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

  // 🟢 تحسين userFriendlyMessage
  String get userFriendlyMessage {
    if (isUnauthorized) {
      return message.isNotEmpty ? message : 'يرجى تسجيل الدخول مرة أخرى';
    } else if (isValidationError && errors != null) {
      // نأخذ أول خطأ من الـ errors object
      final firstError = errors!.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
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
      return message; // نرجع الرسالة الأصلية من الـ API
    }
  }
}