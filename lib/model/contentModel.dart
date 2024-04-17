class ContentModel {
  String title;
  String content;

  ContentModel({required this.title, required this.content});

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      ContentModel(title: json['title'], content: json['content']);
}
