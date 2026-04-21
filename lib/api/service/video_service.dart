import 'package:dio/dio.dart';
import 'package:vidzy/api/api_client.dart';
import 'package:vidzy/api/api_end_point.dart';
import 'package:vidzy/api/model/video_model.dart';
import 'package:vidzy/core/utils/private.dart';

class VideoService {

  final Dio _dio = DioClient().getInstance(
    baseUrl: apiEndPoint.baseUrlVideo,
    headers: {
      "Authorization" : Private.apiKey
    }
  );

  Future<List<VideoModel>> fetchVideos({
    required int page, required String category
  }) async {
    final response = await _dio.get(
        apiEndPoint.categoryVideos,
        queryParameters: {
          'query': category,
          'page': page,
          'per_page': 10,
        }
    );

    final List<dynamic> data = response.data['videos'];

    return data.map((e) {
      final json = e as Map<String, dynamic>;
      final files = json['video_files'] as List;

      // Filter Logic
      final filtered = files.firstWhere(
            (file) => file['quality'] == 'sd',
        orElse: () => files.first,
      );

      return VideoModel.fromJson(json, filtered);
    }).toList();
  }
}