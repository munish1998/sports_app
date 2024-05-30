import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:touchmaster/service/apiConstant.dart';
import 'package:touchmaster/utils/constant.dart';

Future<Map<String, dynamic>?> createPaymentIntent({
  required String currency,
  required String amount,
  required String secretKey,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');

  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Test Donation",
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
