class PersonalizeModel {
  String id;
  String name;
  String title;
  String rewards;
  String rank;
  String image;
  String completionDate;

  PersonalizeModel({
    required this.id,
    required this.name,
    required this.title,
    required this.rewards,
    required this.rank,
    required this.image,
    required this.completionDate,
  });

  factory PersonalizeModel.fromJson(Map<String, dynamic> json) =>
      PersonalizeModel(
          id: json['id'],
          name: json['name'],
          title: json['title'],
          rewards: json['rewards'],
          rank: json['rank'],
          image: json['image'],
          completionDate: json['completion_date']);
}
/*{
            "id": "1",
            "name": "Test Name",
            "title": "Level 1",
            "rewards": "1500",
            "rank": "1",
            "image": "https://www.webpristine.com/Touch-master/media/leaderboard/1.png",
            "completion_date": "05-02-2024"
        }*/
