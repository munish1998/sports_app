class RewardModel {
  String id;
  String title;
  String rewards;

  RewardModel({required this.id, required this.title, required this.rewards});

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
      id: json['id'], title: json['title'], rewards: json['rewards']);
}

/*
* {
            "id": "1",
            "title": "test M2 (Level)",
            "rewards": "1000"
        }*/
