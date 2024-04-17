class CommentModel {
  String comment;
  String dateTime;

  CommentModel({required this.comment, required this.dateTime});

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      CommentModel(comment: json['comment'], dateTime: json['created_on']);
}
