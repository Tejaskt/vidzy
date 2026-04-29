import 'package:vidzy/api/api_client.dart';
import 'package:vidzy/api/api_end_point.dart';
import 'package:vidzy/api/model/video_model.dart';

class VideoService {
  static var shared = VideoService();

  Future<ApiResponse<List<VideoModel>>> fetchVideos({
    required int page,
    required String category,
  }) {
    return client.request(
      url: ApiEndPoint.baseUrlVideo,
      isAuth: true,
      method: HttpMethod.get,
      queryParams: {'query': category, 'page': page, 'per_page': 10},
      fromJson: (data) {

        final List<dynamic> res = data['videos'];

        return res.map((e) {
          final json = e as Map<String, dynamic>;
          final files = json['video_files'] as List;

          // Filter Logic
          final filtered = files.firstWhere(
            (file) => file['quality'] == 'sd',
            orElse: () => files.first,
          );

          return VideoModel.fromJson(json, filtered);
        }).toList();
      },
    );
  }
}
