class SubscriptionModel {
  int? code;
  String? message;
  Subscription? subscription;

  SubscriptionModel({this.code, this.message, this.subscription});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    return data;
  }
}

class Subscription {
  String? orderId;
  String? secretKey;
  String? amount;
  String? currency;
  String? enviroment;
  String? merchantName;

  Subscription(
      {this.orderId,
      this.secretKey,
      this.amount,
      this.currency,
      this.enviroment,
      this.merchantName});

  Subscription.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    secretKey = json['secret_key'];
    amount = json['amount'];
    currency = json['currency'];
    enviroment = json['enviroment'];
    merchantName = json['merchant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['secret_key'] = this.secretKey;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['enviroment'] = this.enviroment;
    data['merchant_name'] = this.merchantName;
    return data;
  }
}
