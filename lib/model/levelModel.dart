class LevelModel {
  String id;
  String title;
  String description;
  String bgImage;
  String duration;
  String exercises;
  String lockstatus;

  LevelModel({
    required this.id,
    required this.title,
    required this.description,
    required this.bgImage,
    required this.duration,
    required this.exercises,
    required this.lockstatus,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
      id: json["id"] ?? '',
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      bgImage: json["bg_image"] ?? '',
      duration: json["duration"] ?? '',
      exercises: json["exercises"] ?? '',
      lockstatus: json[" lock_status"] ?? '');
}
