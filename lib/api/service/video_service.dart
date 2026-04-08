import 'package:dio/dio.dart';
import 'package:vidzy/api/api_end_point.dart';
import 'package:vidzy/api/model/video_model.dart';

class VideoService {

  final Dio dio;
  VideoService(this.dio);

  Future<List<VideoModel>> fetchVideos({int page = 1}) async{
    final response = await dio.get(
        apiEndPoint.natureVideos,
      queryParameters: {
        'page' : page,
        'per_page' : 10,
      }
    );

    final List<dynamic> data = response.data['videos'];
    return data.map((e) => VideoModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}