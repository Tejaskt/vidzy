import 'package:vidzy/api/api_client.dart';
import 'package:vidzy/api/api_end_point.dart';
import 'package:vidzy/api/model/post_model.dart';

class PostService {
  static var shared = PostService();

  Future<ApiResponse<List<PostModel>>> fetchPosts({
    int skip = 0,
    int limit = 10,
  }) {
    return client.request(
      url: ApiEndPoint.baseUrlPost,
      method: HttpMethod.get,
      queryParams: {"skip": skip, "limit": limit},
      fromJson: (data) {
        final List<dynamic> res = data['posts'];
        return res.map((e) => PostModel.fromJson(e)).toList();
      },
    );
  }

}
