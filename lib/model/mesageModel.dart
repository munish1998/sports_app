class MessageModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  String? datetime;

  MessageModel(
      {this.id, this.senderId, this.receiverId, this.message, this.datetime});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    datetime = json['datetime'];
  }
}
