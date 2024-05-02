// // // class ChallengeModel {
// // //   String title;
// // //   List<ItemModel> itemList;
// // //
// // //   ChallengeModel({
// // //     required this.title,
// // //     required this.itemList,
// // //   });
// // //   factory ChallengeModel.fromJson(Map<String, dynamic>json){
// // //
// // //     return ChallengeModel(title: 'title', itemList: []);
// // //   }
// // // }

// // class ChallengeModel {
// //   String id;
// //   String title;
// //   String dateTime;
// //   String status;
// //   String videoId;
// //   String thumbnail;
// //   String video;

// //   ChallengeModel({
// //     required this.id,
// //     required this.title,
// //     required this.dateTime,
// //     required this.status,
// //     required this.videoId,
// //     required this.thumbnail,
// //     required this.video,
// //   });

// //   factory ChallengeModel.fromJson(Map<String, dynamic> json) => ChallengeModel(
// //       id: json['id'],
// //       title: json['title'],
// //       dateTime: json['datetime'] ?? '',
// //       status: json['status'] ?? '',
// //       videoId: json['video_id'] ?? '',
// //       thumbnail: json['thumbnail'] ?? '',
// //       video: json['video'] ?? '');
// // }

// // /*{
// //             "id": "4",
// //             "title": "New Challenge",
// //             "datetime": "15-02-2024 21:43",
// //             "status": "pending",
// //             "video_id": null,
// //             "thumbnail": "",
// //             "video": ""
// //         }*/

class ChallengeModel {
  String? id;
  String? title;
  String? datetime;
  String? status;
  String? videoId;
  String? thumbnail;
  String? video;
  String? senderName;
  String? senderUserId;
  String? reciverName;
  String? reciverUserId;
  String? action;

  ChallengeModel(
      {this.id,
      this.title,
      this.datetime,
      this.status,
      this.videoId,
      this.thumbnail,
      this.video,
      this.senderName,
      this.senderUserId,
      this.reciverName,
      this.reciverUserId,
      this.action});

  ChallengeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    datetime = json['datetime'];
    status = json['status'];
    videoId = json['video_id'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    senderName = json['sender_name'];
    senderUserId = json['sender_user_id'];
    action = json['action'];
  }
}

// class ChallengeModel {
//   String id;
//   String title;
//   String dateTime;
//   String status;
//   String videoId;
//   String thumbnail;
//   String video;

//   ChallengeModel({
//     required this.id,
//     required this.title,
//     required this.dateTime,
//     required this.status,
//     required this.videoId,
//     required this.thumbnail,
//     required this.video,
//   });

//   factory ChallengeModel.fromJson(Map<String, dynamic> json) => ChallengeModel(
//       id: json['id'],
//       title: json['title'],
//       dateTime: json['datetime'] ?? '',
//       status: json['status'] ?? '',
//       videoId: json['video_id'] ?? '',
//       thumbnail: json['thumbnail'] ?? '',
//       video: json['video'] ?? '');
// }
