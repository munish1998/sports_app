class LeaderboardModel {
  String id;
  String userId;
  String name;
  String title;
  String reward;
  String rank;
  String completionDate;
  String profileImage;

  LeaderboardModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.title,
    required this.reward,
    required this.rank,
    required this.completionDate,
    required this.profileImage,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) =>
      LeaderboardModel(
        id: json['id'],
        userId: json['user_id'] ?? '',
        name: json['name'] ?? '',
        title: json['title'] ?? '',
        reward: json['rewards'] ?? '',
        rank: json['rank'] ?? '',
        completionDate: json['completion_date'] ?? '',
        profileImage: json['profile_picture'] ?? '',
      );
}
/*{
      "name": "Test Name",
      "title": "Level 1",
      "rewards": "1500",
      "rank": "4",
      "completion_date": "04-02-2024",
      "profile_picture": "https://www.webpristine.com/Touch-master/media/users/profile/155819939909012024224424.png"
    }*/
