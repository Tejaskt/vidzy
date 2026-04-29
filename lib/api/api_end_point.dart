class ApiEndPoint {

  ApiEndPoint._i();

  static const String mimeJson = 'application/json';
  static const String mimeFormD0ata = 'multipart/form-data';
  static const String mimeURLEncoded = 'application/x-www-form-urlencoded';
  static const dynamic defaultRequestForCallBack = {"screen": "mobile"};

  /// Default BaseUrl
  static const String baseUrl = '';

  static const String baseUrlDummyJson = 'https://dummyjson.com';

  /// BASE URL FOR VIDEOS
  static const String baseUrlVideo = 'https://api.pexels.com/v1/videos/search';

  /// BASE URL FOR COMMENTS
  static const String baseUrlComment = '$baseUrlDummyJson/comments/post/';

  /// BASE URL FOR POST
  static const String baseUrlPost = '$baseUrlDummyJson/posts';

  /// BASE URL FOR USERS
  static const String baseUrlUsers = '$baseUrlDummyJson/users/';

  /// BASE URL : IMAGE NOT AVAILABLE.
  /// https://dummyimage.com/
  static const String baseUrlImageNotAvailable = '$baseUrlDummyJson/400x400/000/fff&text=N/A';

}