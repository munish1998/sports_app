// // ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, library_private_types_in_public_api

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_stripe/flutter_stripe.dart';

// class StripePayement extends StatefulWidget {
//   const StripePayement({Key? key}) : super(key: key);

//   @override
//   _StripePayementState createState() => _StripePayementState();
// }

// class _StripePayementState extends State<StripePayement> {
//   Map<String, dynamic>? paymentIntent;
//   Future<void> makepayment() async {
//     try {
//       paymentIntent = await createPaymentIntent();
//       var gpay =
//           PaymentSheetGooglePay(merchantCountryCode: "US", currencyCode: "US");
//       Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: paymentIntent!["client_secret"],
//             style: ThemeMode.dark,
//             googlePay: gpay),
//       );
//       //displayPaymentSheet();
//       displaypaymentsheet();
//     } catch (e) {
//       log('payment sheet response ===>>>$e');
//     }
//   }

//   Future<void> displaypaymentsheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       log('payment success');
//     } catch (e) {
//       log('payment failed====');
//     }
//   }

//   createPaymentIntent() async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': '1000',
//         'currency': 'USD',
//         // 'payment_method_types[]': 'card',
//       };
//       log('$body');
//       http.Response response = await http.post(
//           Uri.parse('https://api.stripe.com/v1/payment_intents'),
//           body: body,
//           headers: {
//             'Authorization':
//                 'Bearer sk_test_51PDi6gSFgGEQSEVhcu1FTRYpp76ans5GsPVARVyKyspPfrPsrA4PCuysVVH26il0p6c2xNzYndfieM0UcV4TxgZi00chCpHBl9',
//             'Content-Type': 'application/x-www-form-urlencoded'
//           });
//       // log('Create Intent reponse ===> ${response.body.toString()}');
//       return jsonDecode(response.body);
//     } catch (err) {
//       log('err charging user: ${err.toString()}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stripe Tutorial'),
//       ),
//       body: Center(
//         child: InkWell(
//           onTap: () async {
//             // final paymentMethod = await Stripe.instance.createPaymentMethod(
//             //     params: const PaymentMethodParams.card(
//             //         paymentMethodData: PaymentMethodData()));
//             await makepayment();
//           },
//           child: Container(
//             height: 50,
//             width: 200,
//             color: Colors.green,
//             child: const Center(
//               child: Text(
//                 'Pay',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// //  Future<Map<String, dynamic>>

// calculateAmount(String amount) {
//   final a = (int.parse(amount)) * 100;
//   return a.toString();
// }
