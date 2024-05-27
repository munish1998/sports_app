import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:touchmaster/service/apiConstant.dart';
import 'package:touchmaster/utils/constant.dart';

Future<Map<String, dynamic>?> createPaymentIntent({
  required String name,
  required String address,
  required String pin,
  required String city,
  required String state,
  required String country,
  required String currency,
  required String amount,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  final secretKey =
      'sk_test_51PDi6gSFgGEQSEVhcu1FTRYpp76ans5GsPVARVyKyspPfrPsrA4PCuysVVH26il0p6c2xNzYndfieM0UcV4TxgZi00chCpHBl9';
  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Test Donation",
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][postal_code]': pin,
    'shipping[address][city]': city,
    'shipping[address][state]': state,
    'shipping[address][country]': country
  };

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $secretKey",
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: body,
  );

  log('Request Body: $body');

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    log('Response Body: ${response.body}');
    log('Response Status Code: ${response.statusCode}');
    return json;
  } else {
    log('Payment intent creation failed with status code: ${response.statusCode}');
    log('Response Body: ${response.body}');
    return null;
  }
}

Future<Map<String, dynamic>?> createPaymentIntent1({String? userID}) async {
  final url = Uri.parse(Apis.buySubscription);
  final secretKey =
      'sk_test_51PDi6gSFgGEQSEVhcu1FTRYpp76ans5GsPVARVyKyspPfrPsrA4PCuysVVH26il0p6c2xNzYndfieM0UcV4TxgZi00chCpHBl9';
  final body = {
    'user_id': 'TM-0031',
    'plan_id': '3',
    // 'automatic_payment_methods[enabled]': 'true',
    // 'description': "Test Donation",
    // 'shipping[name]': name,
    // 'shipping[address][line1]': address,
    // 'shipping[address][postal_code]': pin,
    // 'shipping[address][city]': city,
    // 'shipping[address][state]': state,
    // 'shipping[address][country]': country
  };

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $secretKey",
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: body,
  );

  log('Request Body: $body');

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    log('Response Body: ${response.body}');
    log('Response Status Code: ${response.statusCode}');
    return json;
  } else {
    log('Payment intent creation failed with status code: ${response.statusCode}');
    log('Response Body: ${response.body}');
    return null;
  }
}
