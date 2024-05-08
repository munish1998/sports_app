import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future createPaymentIntent(
    {required String name,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String currency,
    required String amount}) async {
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

  final response = await http.post(url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body);

  log('body response ===>>>>>$body');

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    log('json response====>>>$json');
    log('response.statuscode=====2000=====>>>>>$response');
    return json;
  } else {
    log('payment intent failed=====>>>>>$response');
  }
}
