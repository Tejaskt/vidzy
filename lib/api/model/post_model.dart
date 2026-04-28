class PostModel {
  final String title;
  final String body;
  final List<dynamic> tags;
  final int likes;
  final int dislikes;
  final int views;
  final int userId;

  PostModel({required this.title, required this.body, required this.tags, required this.likes, required this.dislikes, required this.views, required this.userId});

  factory PostModel.fromJson(
    Map<String, dynamic> json
  ){
    return PostModel(
        title: json['title'],
        body: json['body'],
        tags: json['tags'],
        likes: json['reactions']['likes'],
        dislikes: json['reactions']['dislikes'],
        views: json['views'],
        userId: json['userId']
    );
  }
}