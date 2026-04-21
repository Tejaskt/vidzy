class CommentModel {
  final String body;
  final int likes;
  final String user;

  CommentModel({
    required this.body,
    required this.likes,
    required this.user
  });

  factory CommentModel.fromJson(
      Map<String, dynamic> json
  ){
    return CommentModel(
        body: json['body'],
        likes: json['likes'],
        user: json['user']['username']
    );
  }
}
