import 'package:dio/dio.dart';

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
            }
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



