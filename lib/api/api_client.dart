import 'package:dio/dio.dart';
import 'api_end_point.dart';

//APIClient apiClient = APIClient();
class DioClient {

  late Dio _dio;
  Dio get dio => _dio;

  DioClient(String apiKey) {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiEndPoint.baseUrl,
        headers: {
          'Authorization': apiKey,
        },
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 3),
      ),
    );

    _dio.interceptors.add(_logInterceptor());
  }

  Interceptor _logInterceptor() {
    return LogInterceptor(
      responseBody: true,
      request: true,
      responseHeader: true,
      requestHeader: true,
      requestBody: true,
      error: true,
    );
  }

}


