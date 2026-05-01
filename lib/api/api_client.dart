import 'package:dio/dio.dart';
import 'package:vidzy/core/utils/private.dart';
import 'package:vidzy/res/app_strings.dart';

import '../core/error/app_exception.dart';
import 'api_end_point.dart';

APIClient client = APIClient.shared;

class APIClient {
  static APIClient shared = APIClient();

  Future<Dio> getApiClient({
    String? content = ApiEndPoint.mimeJson,
    bool isAuth = false
  }) async{
    Dio dio = Dio(
        BaseOptions(
            baseUrl: ApiEndPoint.baseUrl,
            connectTimeout: const Duration(minutes: 5),
            receiveTimeout: const Duration(minutes: 3),
          contentType: content
        )
    );

    dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        request: true,
        responseHeader: false,
        requestHeader: false,
        requestBody: true,
        error: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async{
          if(isAuth){
            options.headers['Authorization'] = Private.apiKey;
          }
          handler.next(options);
        },
      )
    );
    return dio;
  }

  Future<ApiResponse<T>> request<T>({
    required String url,
    required HttpMethod method,
    Map<String, dynamic>? queryParams,
    dynamic data,
    String contentType = Headers.jsonContentType,
    required T Function(Map<String, dynamic>) fromJson,
    bool isAuth = false
  }) async{
    try{
      APIClient apiClient = APIClient();
      Dio dio = await apiClient.getApiClient(
        content: contentType,
        isAuth: isAuth
      );

      late Response response;

      switch(method){

        case HttpMethod.get:
          response = await dio.get(url, queryParameters: queryParams);
          break;

        case HttpMethod.post:
          response = await dio.post(
            url,
            data: data,
            queryParameters: queryParams
          );
          break;

        case HttpMethod.put:
          response = await dio.put(url, data: data);
          break;

        case HttpMethod.patch:
          response = await dio.patch(url, data: data);
          break;

        case HttpMethod.delete:
          response = await dio.delete(url, data:data);
          break;
      }

      return ApiResponse<T>.fromJson(response.data, fromJson);
    }on DioException catch(e){
      throw catchError(e);
    }
  }
}

Object catchError(DioException error) {
  if (error.type == DioExceptionType.connectionError) {
    throw AppException(AppStrings.noInternet, code: -1);
  } else if (error.response != null) {
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        throw AppException(AppStrings.badRequest, code: statusCode);
      case 401:
        throw AppException(AppStrings.unAuthorized, code: statusCode);
      case 404:
        throw AppException(AppStrings.recourseNotFound, code: statusCode);
      case 408:
        throw AppException(AppStrings.connectionTimeOUt, code: statusCode);
      case 500:
        throw AppException(AppStrings.serverError, code: statusCode);
      default:
        throw AppException(AppStrings.somethingWentWrong, code: statusCode);
    }
  } else {
    throw AppException(AppStrings.unexpectedError, code: -1);
  }
}

enum HttpMethod { get, post, put, delete, patch }

class ApiResponse<T> {
  T? data;
  String? message;
  bool? status;
  int? code;

  ApiResponse({this.data, this.message, this.status, this.code});

  factory ApiResponse.fromJson(
      Map<String, dynamic>? json,
      T Function(Map<String, dynamic>) create,
      ) {

    // If API doesn't wrap response → treat whole JSON as data
    if (json != null && !json.containsKey("data")) {

      return ApiResponse<T>(
        data: create(json),
        message: null,
        status: true,
        code: 200,
      );
    }

    return ApiResponse<T>(
      data: json?["data"] != null ? create(json!["data"]) : null,
      message: json?["message"],
      status: json?["status"],
      code: json?["code"],
    );
  }
}


