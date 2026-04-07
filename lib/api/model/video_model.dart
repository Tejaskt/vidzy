class VideoModel {
  final int id;
  final String videoUrl;
  final String thumbnail;
  final String userName;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnail,
    required this.userName,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final files = json['video_files'] as List;

    // FILTER LOGIC
    final filtered = files.where((file) {
      return file['height'] > file['width'] &&
          file['quality'] != 'uhd';
    }).toList();

    final selected = filtered.isNotEmpty ? filtered.first : files.first;

    return VideoModel(
      id: json['id'],
      videoUrl: selected['link'],
      thumbnail: json['image'],
      userName: json['user']['name'],
    );
  }
}