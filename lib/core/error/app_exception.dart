import 'package:dio/dio.dart';
import 'package:vidzy/res/app_strings.dart';

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
        return AppException(AppStrings.connectionTimeOUt);

      case DioExceptionType.receiveTimeout:
        return AppException(AppStrings.receiveTimeOut);

      case DioExceptionType.badResponse:
        return AppException(
          error.response?.data["message"] ?? AppStrings.serverError,
        );

      case DioExceptionType.cancel:
        return AppException(AppStrings.requestCancelled);

      default:
        return AppException("${AppStrings.somethingWentWrong} ${error.message}");
    }
  }
}
