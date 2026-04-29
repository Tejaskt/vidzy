import '../model/post_model.dart';
import '../model/video_model.dart';

class FeedModel {
  final VideoModel? video;
  final PostModel? post;

  FeedModel({
    this.video,
    this.post,
  });
}