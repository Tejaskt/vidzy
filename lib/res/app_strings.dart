class AppStrings {
  AppStrings._();

  static const String appName = 'Vidzy';

  /// category list
  static List<String> get categoryList => ['animal','nature','dance','fight','country','tech','sunset','space','storm','ufo','racing','guns'];

  /// network error
  static const String noInternet = 'No internet connection';
  static const String unexpectedError = 'Unexpected error occurred';
  static const String connectionTimeOUt = 'Connection timeout';
  static const String sendTimeOut = 'Send timeout';
  static const String receiveTimeOut = 'Receive timeout';
  static const String serverError = 'Server Error';
  static const String requestCancelled = 'Request cancelled';
  static const String somethingWentWrong = 'something went wrong';
  static const String recourseNotFound = 'Resource not found';
  static const String unAuthorized = 'Unauthorized';
  static const String badRequest = 'Bad Request';
  static const String forbiddenRequest = 'Forbidden request';
  static const String serviceUnavailable = 'Service unavailable';
  static const String internalServerError = 'Internal server error';
  static const String videoFetchError = 'Unable to Fetch the videos';
  static const String commentFetchError = 'Unable to Fetch the comments';
  static const String postFetchError = 'Unable to Fetch the posts';
  static const String userFetchError = 'Unable to Fetch the user image';
  static const String failedToLoadFeed = 'Failed to load feed';
  static const String retry = 'Retry';

  /// dashboard screen
  static const String chooseCategory = 'Popular Categories';
  static const String enterCategoryHint = 'enter category here';

  /// Video Item
  static const String qualityAuto = 'Auto';
  static const String unknownUser = 'unknow user';
  static const String titleNA = 'title not available';
  static const String tagsNA = '#unknown #tags';
  static const String bodyNA = 'body not available of post';

  /// comment bottom sheet
 static const String comments = 'Comments';
 static const String noComments = 'No comments yet.';


}
