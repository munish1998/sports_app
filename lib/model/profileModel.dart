class ProfileModel {
  String name;
  String email;
  String contactNumber;
  String type;
  String profilePicture;
  String location;
  String bgProfile;
  String country;
  String city;
  String area;

  ProfileModel({
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.type,
    required this.profilePicture,
    required this.location,
    required this.bgProfile,
    required this.country,
    required this.city,
    required this.area,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        name: json["name"],
        email: json["email"],
        contactNumber: json["contact_number"],
        type: json["type"],
        profilePicture: json["profile_picture"],
        location: json["location"],
        bgProfile: json["bg_picture"],
        country: json["country"],
        city: json["city"],
        area: json["area"],
      );
}
