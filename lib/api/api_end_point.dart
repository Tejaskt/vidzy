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

  /// BASE URL FOR VIDEOS
  final String baseUrlVideo = 'https://api.pexels.com/v1/';

  /// BASE URL FOR COMMENTS
  final String baseUrlComment = 'https://dummyjson.com/comments/post/';
  // POPULAR VIDEOS
  final String popularVideos = 'videos/popular';

  final String categoryVideos = 'videos/search';

}