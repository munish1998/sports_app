class PracticeCateModel {
  String id;
  String title;

  PracticeCateModel({
    required this.id,
    required this.title,
  });

  factory PracticeCateModel.fromJson(Map<String, dynamic> json) =>
      PracticeCateModel(
        id: json["id"] ?? '',
        title: json["title"] ?? '',
      );
}

class PracticeModel {
  String id;
  String categoryId;
  String title;
  String description;
  String bgImage;
  String video;
  String durationType;
  String duration;

  PracticeModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.bgImage,
    required this.video,
    required this.durationType,
    required this.duration,
  });

  factory PracticeModel.fromJson(Map<String, dynamic> json) => PracticeModel(
        id: json["id"] ?? '',
        categoryId: json["category_id"] ?? '',
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        bgImage: json["bg_image"],
        video: json["video"] ?? '',
        durationType: json["duration_type"] ?? '',
        duration: json["duration"] ?? '',
      );
}
