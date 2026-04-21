class VideoModel {
  final String videoUrl;
  final String thumbnail;
  final String userName;
  final String? quality;

  VideoModel({
    required this.videoUrl,
    required this.thumbnail,
    required this.userName,
    required this.quality,
  });

  factory VideoModel.fromJson(
      Map<String, dynamic> json,
      Map<String, dynamic> file
  ) {

    return VideoModel(
      videoUrl: file['link'],
      thumbnail: json['image'],
      userName: json['user']['name'],
      quality: file['quality'],
    );
  }
}

/*
*

import 'package:dio/dio.dart';

import '../constants/app_string.dart';

class DioClient {
  static final DioClient _dioClient = DioClient._internal();

  DioClient._internal();

  factory DioClient() => _dioClient;

  final Map<String, Dio> _instances = {};


  /// putIfAbsent has two parameters(key, dio function)
  /// key in our case is baseUrl: everytime it will check if baseUrl exists in map it will return the dio object in our case.
  /// now if value is not in map. value will be added in the map so next time when it get called it will return same dio...

  Dio getInstance({required String baseUrl,Map<String,dynamic>? headers}){
    return _instances.putIfAbsent(baseUrl, () => _createDio(baseUrl,headers),);
  }

  Dio _createDio(String baseUrl, Map<String,dynamic>? headers)
  {

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 5)
      )
    );

    dio.interceptors.addAll(
        [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              options.headers = {
                "Content-Type" : "application/json",
                ...?headers,
              };
              handler.next(options);
            },
            onError: (error, handler) {
              final message = _getErrorMessage(error);
              return handler.reject(
                DioException(
                    requestOptions: error.requestOptions, //information about the API request that failed. internally managed by dio..
                    message: message, //our custom message
                    type: error.type //type of the error like timeout, network issue...
                ),
              );
            },
          ),
          LogInterceptor(
              responseBody: true,
              error: true
          )
        ]
    );

    return dio;
  }

}


String _getErrorMessage(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return AppString.connectionTimeout;
    case DioExceptionType.receiveTimeout:
      return AppString.receiveTimeout;
    case DioExceptionType.connectionError:
      return AppString.connectionError;
    case DioExceptionType.badResponse:
      final status = error.response?.statusCode;
      if (status == 401) return AppString.badResponse401;
      if (status == 429) return AppString.badResponse402;
      return AppString.somethingWrong;
    default:
      return AppString.somethingWrong;
  }
}

*
* */

