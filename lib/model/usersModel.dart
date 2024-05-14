class UsersModel {
  String userId;
  String name;
  String location;
  String profilePicture;
  String type;
  String follow;
  bool challengeSent;

  UsersModel(
      {required this.userId,
      required this.name,
      required this.location,
      required this.profilePicture,
      required this.type,
      required this.follow,
      this.challengeSent = false});

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        userId: json["user_id"] ?? '',
        name: json["name"] ?? '',
        location: json["location"] ?? '',
        profilePicture: json["profile_picture"] ?? '',
        type: json["type"] ?? '',
        follow: json["follow"] ?? '',
        challengeSent: false,
      );
}
