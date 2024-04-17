class ProfileVideoModel {
  String videoId;
  String title;
  String uName;
  String uType;
  String uProfile;
  String description;
  String thumbnail;
  String video;
  String videoLength;
  String totalViews;
  String totalLikes;
  String totalShare;
  String totalSave;
  String totalComments;
  bool isLiked;

  ProfileVideoModel({
    required this.videoId,
    required this.title,
    required this.uName,
    required this.uType,
    required this.uProfile,
    required this.description,
    required this.thumbnail,
    required this.video,
    required this.videoLength,
    required this.totalViews,
    required this.totalLikes,
    required this.totalShare,
    required this.totalSave,
    required this.totalComments,
    required this.isLiked,
  });

  factory ProfileVideoModel.fromJson(Map<String, dynamic> json) =>
      ProfileVideoModel(
        videoId: json["video_id"],
        title: json["title"],
        uName: json["name"],
        uType: json["type"],
        uProfile: json["profile_picture"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        video: json["video"],
        videoLength: json["video_length"],
        totalViews: json["total_views"],
        totalLikes: json["total_likes"],
        totalShare: json["total_share"],
        totalSave: json["total_save"],
        totalComments: json["total_comments"],
        isLiked: json["is_liked"],
      );
}
