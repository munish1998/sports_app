import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/customLoader.dart';
import '../home/dashboard.dart';
import '/app_image.dart';
import '/providers/authProvider.dart';
import '/screens/authScreen/forotPassScreen.dart';
import '/utils/commonMethod.dart';
import '/utils/size_extension.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  bool isPass = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    _getAddress();
  }

  _getAddress() async {
    var pro = Provider.of<AuthProvider>(context, listen: false);
    pro.getAddress();
    pro.getToken();
    pro.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Consumer<AuthProvider>(builder: (context, data, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
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
                  "sign in to access your account",
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Form(
                      child: Column(
                    children: [
                      TextFormField(
                        controller: data.lEmailController,
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
                            hintText: "Email Id",
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
                      TextFormField(
                        controller: data.lPassController,
                        keyboardType: TextInputType.visiblePassword,
                        style: GoogleFonts.mulish(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffFFFFFF),
                        ),
                        obscureText: !isPass,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isPass = !isPass;
                                });
                              },
                              child: Icon(
                                (isPass)
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white.withOpacity(0.5),
                                size: 20,
                              ),
                            ),
                            hintText: "Password",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                      color: isChecked
                                          ? const Color(0xff02B660)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: isChecked
                                            ? const Color(0xff02B660)
                                            : Colors.white,
                                      )),
                                  child: isChecked
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 13,
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                              Text(
                                "  Remember me",
                                style: GoogleFonts.mulish(
                                  color: const Color(0xffffffff),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              navPush(
                                  context: context, action: ForgotPassScreen());
                            },
                            child: Text(
                              "Forget password ?",
                              style: GoogleFonts.mulish(
                                color: const Color(0xff02B660),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
                ),
                SizedBox(
                  height: 240,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: button(
                        label: 'SIGN IN', isNext: false, onTap: onLogin)),

                SizedBox(
                  height: 20,
                ),
                //New Member? Register now

                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignUpScreen();
                    }));
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "New Member?",
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "  Register now",
                      style: GoogleFonts.mulish(
                        color: const Color(0xff02B660),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ])),
                ),
                SizedBox(
                  height: 80,
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> onLogin() async {
    var pro = Provider.of<AuthProvider>(context, listen: false);
    var data = {};
    if (pro.lEmailController.text.isEmpty) {
      customToast(context: context, msg: 'Email ID required', type: 0);
    } else if (!emailExpression.hasMatch(pro.lEmailController.text)) {
      customToast(context: context, msg: 'Enter valid Email ID', type: 0);
    } else if (pro.lPassController.text.isEmpty) {
      customToast(context: context, msg: 'Please enter password', type: 0);
    } else if (pro.lPassController.text.length < 8) {
      customToast(
          context: context, msg: 'Please enter 8 digit password', type: 0);
    } else {
      data = {
        'email': pro.lEmailController.text,
        'password': pro.lPassController.text,
        'location': pro.address,
        'fcm_id': pro.token,
      };
      pro.login(context: context, data: data).then((value) {
        if (pro.isLogin) {
          log('Login Here-------------------- $data');
          navPushRemove(context: context, action: DashboardScreen());
        }
      });
    }
    // log('Login Here-------------------- $data');
  }
}
