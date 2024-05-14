import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/utils/constant.dart';
import 'color.dart';

var emailExpression = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]{2}");

RegExp regex1 =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

RegExp regex = RegExp(r'^[a-zA-Z0-9_]*$');

var regIFSC = RegExp(r"^[A-Z]{4}[0]{1}[A-Z0-9]{6}");
var regPan = RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}");

var regUPI = RegExp('/[a-zA-Z0-9_]{3,}@[a-zA-Z]{3,}/');

String dateTimeFormat(String format, String dateTime) {
  return DateFormat(format).format(DateTime.parse(dateTime));
}

String capitalize(String string) {
  if (string == '') {
    throw ArgumentError("CapitalString: $string");
  }
  if (string.isEmpty) {
    return string;
  }
  return string[0].toUpperCase() + string.substring(1);
}

Future<void> navPush(
    {required BuildContext context, required Widget action}) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (ctx) => action),
  );
}

void navPushReplace({required BuildContext context, required Widget action}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (ctx) => action),
  );
}

void navPushRemove({required BuildContext context, required Widget action}) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (ctx) => action), (route) => false);
}

void navPop({required BuildContext context}) {
  Navigator.pop(context);
}

Widget viewAllButton(
        {required BuildContext context,
        required double radius,
        required Widget action}) =>
    InkWell(
      onTap: () {
        navPush(context: context, action: action);
      },
      child: Container(
        alignment: Alignment.center,
        height: 30,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius), color: primary),
        child: Text(
          'View All',
          style: TextStyle(fontSize: 11, color: white),
        ),
      ),
    );

String timeAgo(int time) {
  DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
  final date2 = DateTime.now();
  final difference = date2.difference(notificationDate);
  log('Date==>>  $notificationDate');
  log('Date==>>  ${difference.inDays}');
  if (difference.inDays >= 2) {
    return dateTimeFormat('dd MMM, yyyy', '$notificationDate');
  }
  /*if (difference.inDays > 15) {
      return '2 Weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    }*/
  else if (difference.inDays >= 1) {
    return 'Yesterday';
  } else if (difference.inHours >= 2) {
    return 'Today';
  } else if (difference.inHours >= 1) {
    return '1 hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return '1 minute ago';
  } else if (difference.inSeconds >= 3) {
    return '${difference.inSeconds} seconds ago';
  } else {
    return 'Just now';
  }
}

Widget button(
        {required String label,
        required bool isNext,
        required Function() onTap}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                tileMode: TileMode.clamp,
                colors: [
                  Color(0xff02B660),
                  Color(0xff51CDE2),
                ])),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              (isNext)
                  ? Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 18,
                    )
                  : SizedBox(
                      width: 0,
                      height: 0,
                    )
            ],
          ),
        ),
      ),
    );

void commonAlert(BuildContext context, String message) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return Theme(
        data: ThemeData
            .dark(), // Set theme to dark to change background color to black
        child: CupertinoAlertDialog(
          title: Text(
            appName,
            style: TextStyle(
              color: Colors.white, // Set title text color to white
            ),
          ),
          content: Container(
            padding: EdgeInsets.all(15),
            // color: Colors.black, // Set content background color to black
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14), // Set content text color to white
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: primary, // Set button background color to green
                  borderRadius: BorderRadius.circular(
                      15), // Optional: Add border radius for button
                ),
                child: Text(
                  'Ok',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16), // Set button text color to white
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

String videoTime(String time) {
  int pos = time.lastIndexOf('.');
  String newTime = (pos >= 0) ? time.substring(0, pos) : time;
  return newTime;
}

String amountFormat(String price) {
  String priceInText = "";
  int counter = 0;
  for (int i = (price.length - 1); i >= 0; i--) {
    counter++;
    String str = price[i];
    if ((counter % 3) != 0 && i != 0) {
      priceInText = "$str$priceInText";
    } else if (i == 0) {
      priceInText = "$str$priceInText";
    } else {
      priceInText = ",$str$priceInText";
    }
  }
  return priceInText.trim();
}

OutlineInputBorder get border => OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(width: 1, color: white),
    );
