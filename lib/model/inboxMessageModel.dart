class MessageInboxModel {
  String? userId;
  String? userName;
  String? profilePicture;
  String? lastMessage;
  String? unreadCount;
  String? datetime;

  MessageInboxModel(
      {this.userId,
      this.userName,
      this.profilePicture,
      this.lastMessage,
      this.unreadCount,
      this.datetime});

  MessageInboxModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    profilePicture = json['profile_picture'];
    lastMessage = json['last_message'];
    unreadCount = json['unread_count'];
    datetime = json['datetime'];
  }
}
