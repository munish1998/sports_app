import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../app_image.dart';
import '../../providers/authProvider.dart';
import '../../utils/color.dart';
import '../../utils/commonMethod.dart';
import '../../utils/customLoader.dart';
import '/screens/authScreen/verification.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              navPop(context: context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Consumer<AuthProvider>(builder: (context, data, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  AppImage(
                    "assets/logo.png",
                    height: 73,
                    width: 66,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Welcome back".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "BankGothic",
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Forgot password to access your account",
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                        child: Column(
                      children: [
                        TextFormField(
                          controller: data.fEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF),
                          ),
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white.withOpacity(0.5),
                                size: 20,
                              ),
                              hintText: "example@mail.com",
                              hintStyle: GoogleFonts.mulish(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xffFFFFFF).withOpacity(0.5),
                              ),
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor:
                                  const Color(0xffC4C4C4).withOpacity(0.2)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: button(
                          label: 'FORGOT PASSWORD',
                          isNext: false,
                          onTap: onForgot)),

                  SizedBox(
                    height: 20,
                  ),
                  //New Member? Register now

                  SizedBox(
                    height: 80,
                  )
                ],
              );
            }),
          ),
        ));
  }

  Future<void> onForgot() async {
    var pro = Provider.of<AuthProvider>(context, listen: false);
    var data = {};
    if (pro.fEmailController.text.isEmpty) {
      customToast(context: context, msg: 'Email ID required', type: 0);
    } else if (!emailExpression.hasMatch(pro.fEmailController.text)) {
      customToast(context: context, msg: 'Enter valid Email ID', type: 0);
    } else {
      data = {
        'email': pro.fEmailController.text,
      };
      pro.forgotPass(context: context, data: data).then((value) {
        if (pro.isForgot) {
          log('Login Here-------------------- $data');
          navPush(context: context, action: VerificationScreen());
        }
      });
    }
    // log('Login Here-------------------- $data');
  }
}
