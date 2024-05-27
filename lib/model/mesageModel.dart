class MessageModel {
  String? id;
  String? senderId;
  String? senderName;
  String? senderPicture;
  String? receiverId;
  String? receiverName;
  String? receiverPicture;
  String? message;
  String? imageUrl;
  String? datetime;

  MessageModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.message,
      this.datetime,
      required String filename});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    senderName = json['sender_name'];
    senderPicture = json['sender_picture'];
    receiverId = json['receiver_id'];
    receiverName = json['receiver_name'];
    receiverPicture = json['receiver_picture'];
    message = json['message'];
    imageUrl = json['filename'];
    datetime = json['datetime'];
  }
}
