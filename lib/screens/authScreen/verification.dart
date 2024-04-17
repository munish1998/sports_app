import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '/providers/authProvider.dart';
import '/screens/authScreen/changePassScreen.dart';
import '/screens/home/dashboard.dart';
import '/utils/commonMethod.dart';
import '/utils/customLoader.dart';
import '/utils/size_extension.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Consumer<AuthProvider>(builder: (context, data, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  "Almost   there".toUpperCase(),
                  style: TextStyle(
                    fontFamily: "BankGothic",
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                RichText(
                  maxLines: 2,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Please enter the 4-digit code sent to your\n",
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          // fontSize: 13.sp,
                          // fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: "email ",
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                          text: data.emailController.text,
                          style: GoogleFonts.mulish(
                            color: const Color(0xff02B660),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          )),
                      TextSpan(
                        text: " for verification.",
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 36,
                  ),
                  child: SizedBox(
                    height: 40.h,
                    child: OTPTextField(
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      contentPadding: const EdgeInsets.all(5),
                      fieldWidth: 35.w,
                      isDense: true,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        data.otpController.text = value;
                      },
                      otpFieldStyle: OtpFieldStyle(
                        // backgroundColor: Colors.white,
                        //backgroundColor: Colors.black,
                        borderColor: const Color(0xffC4C4C4).withOpacity(0.2),

                        focusBorderColor:
                            const Color(0xffC4C4C4).withOpacity(0.2),
                        backgroundColor:
                            const Color(0xffC4C4C4).withOpacity(0.2),
                        disabledBorderColor:
                            const Color(0xffC4C4C4).withOpacity(0.2),
                        enabledBorderColor:
                            const Color(0xffC4C4C4).withOpacity(0.2),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child:
                      button(label: 'Verify', isNext: false, onTap: onVerify),
                ),
                SizedBox(
                  height: 60.h,
                ),
                Center(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Didn’t receive any code? ",
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: "Resend Again",
                      style: GoogleFonts.mulish(
                        color: const Color(0xff02B660),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ])),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(
                          16.r,
                        ) +
                        EdgeInsets.only(left: 5.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void onVerify() async {
    var pro = Provider.of<AuthProvider>(context, listen: false);
    var data = {};
    if (pro.otpController.text.length < 4) {
      customToast(context: context, msg: 'Please enter OTP', type: 0);
    } else {
      data = {
        'user_id': pro.uId,
        'otp': pro.otpController.text,
      };
      if (pro.isForgot) {
        pro.verifyForgotOTP(context: context, data: data).then((value) {
          if (pro.isVerify) {
            navPush(context: context, action: ChangePassScreen());
          }
        });
      } else {
        pro.verifyOTP(context: context, data: data).then((value) {
          if (pro.isVerify) {
            navPushRemove(context: context, action: DashboardScreen());
          }
        });
      }
      log('OTP Fond Here------------${pro.isForgot}-------- $data');
    }
  }
}
