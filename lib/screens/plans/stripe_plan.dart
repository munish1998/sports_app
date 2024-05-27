import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/app_image.dart';
import 'package:touchmaster/model/planModel.dart';
import 'package:touchmaster/providers/planProvider.dart';
import 'package:touchmaster/service/apiConstant.dart';
import 'package:touchmaster/utils/color.dart';
import 'package:touchmaster/utils/constant.dart';
import 'package:touchmaster/utils/size_extension.dart';
import 'package:http/http.dart' as http;

class StripePlan extends StatefulWidget {
  const StripePlan({super.key});

  @override
  State<StripePlan> createState() => _StripePlanState();
}

class _StripePlanState extends State<StripePlan> {
  int initIndex = 0;

  Future<void> subscribeNow() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final planID = '3';

    if (pref != null) {
      final userID = pref.getString(userIdKey).toString();
      if (userID != null && planID != null) {
        try {
          final data = await Provider.of<PlanProvider>(context, listen: false)
              .buySubscription1(
                  context: context,
                  data: {'user_id': userID, 'plan_id': planID});

          log('data response ====>>>>$data');

          if (data != null && data['subscription'] != null) {
            final subscription = data['subscription'];
            final secretKey = subscription['secret_key'];
            final orderID = subscription['order_id'];
            log('subscription response ====>>>>$subscription');
            log('Payment Intent Secret: $secretKey');
            log('Order ID: $orderID');

            try {
              // Initialize the payment sheet
              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: secretKey,
                  merchantDisplayName: 'Touch master',
                  allowsDelayedPaymentMethods: true,
                  // customFlow: true,
                  // customerId: data['order_id']
                  // customerEphemeralKeySecret: data['ephemeralKey'],
                  // paymentIntentClientSecret: data['client_secret'],
                ),
              );
              await Stripe.instance.presentPaymentSheet();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Payment Done",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ));

              setState(() {
                // isPayment = true;
              });
            } catch (e) {
              log("Payment sheet error: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error presenting payment sheet: $e')),
              );
            }
          } else {
            log('Invalid subscription data received');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to retrieve payment details')),
            );
          }
        } catch (e) {
          log("Payment error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } else {
        log('Error: userID or planID is null');
      }
    } else {
      log('Error: SharedPreferences instance is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: AppImage(
          "assets/logo.png",
          height: 30,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      body: Consumer<PlanProvider>(builder: (context, data, child) {
        return ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Container(
                  height: 190,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/ic_planimage.png"),
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Join the",
                                style: TextStyle(
                                    letterSpacing: 4,
                                    fontFamily: "BankGothic",
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "Academy",
                                style: TextStyle(
                                    letterSpacing: 4,
                                    fontFamily: "BankGothic",
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          AppImage(
                            "assets/splash.png",
                            height: 53,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 2,
                        endIndent: 170,
                      ),
                      Text(
                        "Become an Academy member and\nstart training like a pro",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            shadows: [
                              Shadow(
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                  color: Colors.black.withOpacity(0.42))
                            ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFF06B767), Color(0x0006B767)],
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.subscription[initIndex].features.length,
                itemBuilder: ((context, index) {
                  var feature = data.subscription[initIndex].features[index];
                  return Row(
                    children: [
                      Icon(
                        (feature.available == 'yes')
                            ? Icons.check
                            : Icons.clear,
                        color: (feature.available == 'yes') ? primary : red,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        feature.title,
                        style: GoogleFonts.poppins(
                          color: white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }),
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 15,
                  );
                },
              ),
            ),
            Container(
              height: 122,
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.subscription.length,
                itemBuilder: (context, index) {
                  var item = data.subscription[index];
                  Color color;
                  if (item.id == 1) {
                    color = Colors.blue;
                  }
                  return InkWell(
                      onTap: () {
                        setState(() {
                          initIndex = index;
                        });
                      },
                      child: planItem(item));
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 8,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cancel your subscription anytime",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  tileMode: TileMode.clamp,
                  colors: [
                    Color(0xff02B660),
                    Color(0xff51CDE2),
                  ],
                ),
              ),
              child: Center(
                child: InkWell(
                  onTap: () {
                    subscribeNow();
                  },
                  child: Text(
                    "Subscribe Now",
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget planItem(PlanModel item) => Container(
        height: 122,
        margin: EdgeInsets.symmetric(horizontal: 3),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xffFEAD01),
            Color(0xffFEB50D),
            Color(0xffFADC53)
          ]),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              item.planTitle,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "Subscription",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              height: 40,
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: Text(
                  "$currency ${item.planPrice}",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp),
                ),
              ),
            )
          ],
        ),
      );
}
