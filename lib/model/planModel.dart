class PlanModel {
  String id;
  String planTitle;
  String planDuration;
  String planPrice;
  List<Feature> features;

  PlanModel({
    required this.id,
    required this.planTitle,
    required this.planDuration,
    required this.planPrice,
    required this.features,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        id: json["id"],
        planTitle: json["plan_title"],
        planDuration: json["plan_duration"],
        planPrice: json["plan_price"],
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
      );
}

class Feature {
  String title;
  String available;

  Feature({
    required this.title,
    required this.available,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        title: json["title"],
        available: json["available"],
      );
}
