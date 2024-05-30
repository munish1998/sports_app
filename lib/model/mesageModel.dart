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

  MessageModel({
    this.id,
    this.senderId,
    this.senderName,
    this.senderPicture,
    this.receiverId,
    this.receiverName,
    this.receiverPicture,
    this.message,
    this.imageUrl,
    this.datetime,
    required String filename, // Corrected parameter
  }) {
    // Assign the filename to the imageUrl property
    this.imageUrl = filename;
  }

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
