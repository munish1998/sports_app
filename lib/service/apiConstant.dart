const String placeHolder =
    'https://research.cbc.osu.edu/sokolov.8/wp-content/uploads/2017/12/profile-icon-png-898.png';

class Apis {
  static const String baseUrl = 'https://www.webpristine.com/Touch-master/api/';

  static const String imageBaseUrl = baseUrl;

  // static const String baseUrl = 'http://lot.alobhadev.com/';

  //------------------------- Apis -----------------------------
  static const String register = '${baseUrl}user/signup';
  static const String login = '${baseUrl}user/login';
  static const String verifyOtp = '${baseUrl}user/verify_otp';
  static const String forgotPass = '${baseUrl}user/forgot_password';
  static const String verifyForgotOtp =
      '${baseUrl}user/verify_forgot_password_otp';
  static const String changePassword = '${baseUrl}user/change_password';
  static const String getProfile = '${baseUrl}user/my_profile';
  static const String updateProfile = '${baseUrl}user/edit_profile';
  static const String updateProfileBG =
      '${baseUrl}user/edit_profile_bg_picture';
  static const String addContactEnquiry = '${baseUrl}user/add_contact_enquiry';
  static const String subscriptionPlan = '${baseUrl}user/subscriptions';
  static const String about = '${baseUrl}user/about';
  static const String termsCondition = '${baseUrl}user/terms';
  static const String privacyPolicy = '${baseUrl}user/privacy_policy';
  static const String levels = '${baseUrl}user/levels';
  static const String exercises = '${baseUrl}user/exercises';
  static const String subscription = '${baseUrl}user/subscriptions';
  static const String contactUs = '${baseUrl}user/add_contact_enquiry';
  static const String practiceCategory = '${baseUrl}user/practice_categories';
  static const String practices = '${baseUrl}user/practices';
  static const String allUsers = '${baseUrl}user/users';
  static const String followUnfollow = '${baseUrl}user/follower_api';
  static const String completeExercise = '${baseUrl}user/complete_exercise';
  static const String getUsersProfile = '${baseUrl}user/user_profile';
  static const String getRewards = '${baseUrl}user/rewards';
  static const String getQueries = '${baseUrl}user/enquiry_types';
  static const String getLeaderboard = '${baseUrl}user/leaderboard';
  static const String getPersonalizeCard = '${baseUrl}user/personlized_cards';
  static const String getLocation = '${baseUrl}user/locations';
  static const String getNotification = '${baseUrl}user/notifications';
  static const String challengeUser = '${baseUrl}user/challenge_to_user';
  static const String getChallenges = '${baseUrl}user/challenges';
  static const String updatePersonalizeCard =
      '${baseUrl}user/upload_personlized_card_image';
  static const String updateChallengeStatus =
      '${baseUrl}/user/update_challenge_status';

  //-----------Video section

  static const String upLoadVideo = '${baseUrl}video/upload_video';
  static const String getPopularVideo = '${baseUrl}video/popular_video';
  static const String getWatchVideo = '${baseUrl}video/watch_videos';
  static const String getProfileVideo = '${baseUrl}video/get_profile_videos';
  static const String getUsersProfileVideo =
      '${baseUrl}video/get_user_profile_videos';

  static const String addComment = '${baseUrl}video/add_video_comment';
  static const String getComment = '${baseUrl}video/get_video_comments';
  static const String updateVideoStatics =
      '${baseUrl}video/update_video_statistics';
  static const String updateVideoStatus =
      '${baseUrl}video/update_profile_video_status';

  //-------------------Chat section

  static const String addChat = '${baseUrl}chat/add_chat';
  static const String getchatHistory = '${baseUrl}chat/chat_history';
  static const String inboxHistory = '${baseUrl}chat/chat_inbox';
}
