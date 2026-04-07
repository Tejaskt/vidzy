import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

// --- ERROR HANDLER CLASS FOR DIO EXCEPTIONS --- \\
class ErrorHandler {
  static AppException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return AppException("Connection timeout");

      case DioExceptionType.receiveTimeout:
        return AppException("Receive timeout");

      case DioExceptionType.badResponse:
        return AppException(
          error.response?.data["message"] ?? "Server error",
        );

      case DioExceptionType.cancel:
        return AppException("Request cancelled");

      default:
        return AppException("Something went wrong");
    }
  }
}
