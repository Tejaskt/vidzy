class VideoModel {
  final int id;
  final String videoUrl;
  final String thumbnail;
  final String userName;
  final String? quality;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnail,
    required this.userName,
    required this.quality,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final files = json['video_files'] as List;

    // FILTER LOGIC
    final filtered = files.firstWhere(
      (file) => file['quality'] == 'hd',
      orElse: () => files.first,
    );

    return VideoModel(
      id: json['id'],
      videoUrl: filtered['link'],
      thumbnail: json['image'],
      userName: json['user']['name'],
      quality: filtered['quality'],
    );
  }
}
