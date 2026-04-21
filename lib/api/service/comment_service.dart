import 'package:dio/dio.dart';

import '../api_client.dart';
import '../api_end_point.dart';
import '../model/comment_model.dart';

class CommentService {
  final Dio _dio = DioClient().getInstance(
    baseUrl: apiEndPoint.baseUrlComment
  );

  Future<List<CommentModel?>> fetchComments({required int postID}) async {
    final response = await _dio.get(
        '$postID'
    );

    final List<dynamic> data = response.data['comments'];

    return data.map((e) => CommentModel.fromJson(e)).toList();
  }
}
