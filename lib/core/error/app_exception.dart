import 'package:dio/dio.dart';
import 'package:vidzy/res/app_strings.dart';

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
        return AppException(AppStrings.connectionTimeOUt, code: -1);

      case DioExceptionType.sendTimeout:
        return AppException(AppStrings.sendTimeOut, code: -1);

      case DioExceptionType.receiveTimeout:
        return AppException(AppStrings.receiveTimeOut, code: -1);

      case DioExceptionType.connectionError:
        return AppException(AppStrings.noInternet, code: -1);

      case DioExceptionType.cancel:
        return AppException(AppStrings.requestCancelled, code: -1);

      case DioExceptionType.badResponse:
        return _handleStatusCode(error);

      case DioExceptionType.unknown:
      default:
        return AppException(AppStrings.unexpectedError, code: -1);
    }
  }

  // STATUS CODE HANDLING
  static AppException _handleStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = AppStrings.somethingWentWrong;

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
        return AppException(AppStrings.unAuthorized, code: statusCode);

      case 403:
        return AppException(AppStrings.forbiddenRequest, code: statusCode);

      case 404:
        return AppException(AppStrings.recourseNotFound, code: statusCode);

      case 408:
        return AppException(AppStrings.receiveTimeOut, code: statusCode);

      case 422:
        return AppException(message, code: statusCode);

      case 500:
        return AppException(
          AppStrings.internalServerError,
          code: statusCode,
          data: data,
        );

      case 503:
        return AppException(AppStrings.serviceUnavailable, code: statusCode);

      default:
        return AppException(message, code: statusCode);
    }
  }
}