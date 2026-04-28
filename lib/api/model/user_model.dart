class UserModel {
  final String imgUrl;

  UserModel({required this.imgUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(imgUrl: json['image']);
  }
}
