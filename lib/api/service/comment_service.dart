import '../api_client.dart';
import '../api_end_point.dart';
import '../model/comment_model.dart';

class CommentService {
  static var shared = CommentService();

  Future<ApiResponse<List<CommentModel?>>> fetchComments({
    required int postID
  }) async {
    return client.request(
        url: '${ApiEndPoint.baseUrlComment}$postID',
        method: HttpMethod.get,
        fromJson: (data){
          final List<dynamic> res = data['comments'];
          return res.map((e) => CommentModel.fromJson(e)).toList();
        }
    );
  }
}
