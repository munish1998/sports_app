class NotificationModel {
  String id;
  String title;
  String description;
  String dateTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          id: '',
          title: json['title'],
          description: json['description'],
          dateTime: json['datetime']);
}
