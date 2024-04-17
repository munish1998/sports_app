class ExerciseModel {
  String id;
  String title;
  String description;
  String bgImage;
  String video;
  String duration;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.bgImage,
    required this.video,
    required this.duration,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json["id"] ?? '',
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        bgImage: json["bg_image"] ?? '',
        video: json["video"] ?? '',
        duration: json["duration"] ?? '',
      );
}
