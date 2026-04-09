ApiEndPoint apiEndPoint = ApiEndPoint();

class ApiEndPoint {
  static final ApiEndPoint _apiEndPoint = ApiEndPoint._i();

  factory ApiEndPoint() {
    return _apiEndPoint;
  }

  ApiEndPoint._i();

  static const String mimeJson = 'application/json';
  static const String mimeFormD0ata = 'multipart/form-data';
  static const String mimeURLEncoded = 'application/x-www-form-urlencoded';
  static const dynamic defaultRequestForCallBack = {"screen": "mobile"};

  // BASE URL
  final String baseUrl = 'https://api.pexels.com/v1/';

  // POPULAR VIDEOS
  final String popularVideos = 'videos/popular';

  final String categoryVideos = 'videos/search';

}

/*
class APIClient {
  static final APIClient _instance = APIClient._i();

  factory APIClient() => _instance;

  late Dio _dio;
  Dio get dio => _dio;

  APIClient._i() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiEndPoint.baseUrl,
        headers: {
          'Authorization' : '',
        },
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 3),
        contentType: ApiEndPoint.mimeJson,
      ),
    );

    ///  avoid :  Adding interceptor inside every API call || Creating multiple Dio instances
    //_dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_logInterceptor());
  }

  // --- INTERCEPTORS --- \\

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

  /*
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        final token = 'API_KEY';
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(request);
      },

      onError: (DioException e, handler) async {
        return handler.next(e);
      },
    );
  }
   */
}
 */