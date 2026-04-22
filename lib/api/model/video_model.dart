class VideoModel {
  final String videoUrl;
  final String thumbnail;
  final String userName;
  final String? quality;

  VideoModel({
    required this.videoUrl,
    required this.thumbnail,
    required this.userName,
    required this.quality,
  });

  factory VideoModel.fromJson(
      Map<String, dynamic> json,
      Map<String, dynamic> file
  ) {

    return VideoModel(
      videoUrl: file['link'],
      thumbnail: json['image'],
      userName: json['user']['name'],
      quality: file['quality'],
    );
  }
}
