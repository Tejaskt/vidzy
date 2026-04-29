import 'package:vidzy/api/api_client.dart';
import 'package:vidzy/api/model/post_model.dart';
import 'package:vidzy/api/model/video_model.dart';
import 'package:vidzy/api/service/post_service.dart';
import 'package:vidzy/api/service/video_service.dart';
import 'package:vidzy/core/error/app_exception.dart';
import 'package:vidzy/res/app_strings.dart';

class FeedService {
  static final shared = FeedService();

  Future<ApiResponse<T>> _safe<T>(
      Future<ApiResponse<T>> request) async {
    try {
      return await request;
    } on AppException catch (e){
      return ApiResponse<T>(
        data: null,
        message: e.message,
        status: false,
        code: e.code
      );
    } catch (e) {
      return ApiResponse<T>(data : null,message: e.toString(), status: false);
    }
  }

  Future<(List<VideoModel>, List<PostModel>)> fetchFeed({
    required int page,
    required String category,
    required int skip,
  }) async {

    final results = await Future.wait([
      _safe(VideoService.shared.fetchVideos(
        page: page,
        category: category,
      )),
      _safe(PostService.shared.fetchPosts(skip: skip)),
    ]);

    final videoRes = results[0];
    final postRes = results[1];

    if(videoRes.status == false && postRes.status == false){
      throw AppException(
        videoRes.message ?? postRes.message ?? AppStrings.failedToLoadFeed
      );
    }

    final videos = (videoRes.data ?? <VideoModel>[]) as List<VideoModel>;
    final posts = (postRes.data ?? <PostModel>[]) as List<PostModel>;

    return (videos, posts);
  }
}
