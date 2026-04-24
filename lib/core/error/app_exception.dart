import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? code;
  final dynamic data;

  AppException(
      this.message, {
        this.code,
        this.data,
      });

  @override
  String toString() => message;
}

// CENTRALIZED ERROR HANDLER
class ErrorHandler {
  static AppException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return AppException("Connection timeout", code: -1);

      case DioExceptionType.sendTimeout:
        return AppException("Send timeout", code: -1);

      case DioExceptionType.receiveTimeout:
        return AppException("Receive timeout", code: -1);

      case DioExceptionType.connectionError:
        return AppException("No internet connection", code: -1);

      case DioExceptionType.cancel:
        return AppException("Request cancelled", code: -1);

      case DioExceptionType.badResponse:
        return _handleStatusCode(error);

      case DioExceptionType.unknown:
      default:
        return AppException("Unexpected error occurred", code: -1);
    }
  }

  // STATUS CODE HANDLING
  static AppException _handleStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = "Something went wrong";

    if (data is Map<String, dynamic>) {
      message = data["message"] ??
          data["error"] ??
          data["msg"] ??
          message;
    } else if (data is String) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        return AppException(message, code: statusCode);

      case 401:
        return AppException("Unauthorized", code: statusCode);

      case 403:
        return AppException("Forbidden request", code: statusCode);

      case 404:
        return AppException("Resource not found", code: statusCode);

      case 408:
        return AppException("Request timeout", code: statusCode);

      case 422:
        return AppException(message, code: statusCode);

      case 500:
        return AppException(
          "Internal server error",
          code: statusCode,
          data: data,
        );

      case 503:
        return AppException("Service unavailable", code: statusCode);

      default:
        return AppException(message, code: statusCode);
    }
  }
}