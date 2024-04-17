import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../app_image.dart';
import '../../utils/color.dart';
import '../../utils/customLoader.dart';
import '../contentScreen.dart';
import '/providers/authProvider.dart';
import '/providers/contentProvider.dart';
import '/utils/commonMethod.dart';
import '/utils/size_extension.dart';
import 'login.dart';
import 'verification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPass = false;
  bool isCPass = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFun();
  }

  initFun() async {
    var contentPro = Provider.of<ContentProvider>(context, listen: false);
    var auth = Provider.of<AuthProvider>(context, listen: false);
    contentPro.getTnC(context: context);
    contentPro.getPrivacy(context: context);
    contentPro.getAbout(context: context);
    auth.checkOTP();
    auth.getAddress();
    auth.getToken();
    auth.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Consumer2<AuthProvider, ContentProvider>(
              builder: (context, data, content, child) {
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
                  height: 20,
                ),
                Text(
                  "Get   Started".toUpperCase(),
                  style: TextStyle(
                    fontFamily: "BankGothic",
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "by creating a free account",
                  style: GoogleFonts.mulish(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        textField(
                            context: context,
                            controller: data.nameController,
                            hint: 'Name',
                            icon: Icons.person_outlined,
                            isPas: true,
                            index: 0),
                        SizedBox(
                          height: 20,
                        ),
                        textField(
                            context: context,
                            controller: data.emailController,
                            hint: 'Email ID',
                            icon: Icons.email_outlined,
                            isPas: true,
                            index: 1),
                        SizedBox(
                          height: 20,
                        ),
                        textField(
                            context: context,
                            controller: data.phoneController,
                            hint: 'Phone number',
                            icon: Icons.smartphone,
                            isPas: true,
                            index: 2),
                        SizedBox(
                          height: 20,
                        ),
                        textField(
                            context: context,
                            controller: data.countryController,
                            hint: 'Country',
                            icon: Icons.location_searching,
                            isPas: true,
                            index: 3),
                        SizedBox(
                          height: 20,
                        ),
                        textField(
                            context: context,
                            controller: data.cityController,
                            hint: 'City',
                            icon: Icons.location_city,
                            isPas: true,
                            index: 4),
                        SizedBox(
                          height: 20,
                        ),
                        textField(
                            context: context,
                            controller: data.areaController,
                            hint: 'Area',
                            icon: Icons.location_on_outlined,
                            isPas: true,
                            index: 5),
                        SizedBox(
                          height: 20,
                        ),
                        textField(
                            context: context,
                            controller: data.passController,
                            hint: 'Password',
                            icon: (isPass)
                                ? Icons.visibility
                                : Icons.visibility_off,
                            isPas: isPass,
                            index: 6),
                        SizedBox(
                          height: 20,
                        ),
                        textField(
                            context: context,
                            controller: data.cPassController,
                            hint: 'Confirm Password',
                            icon: (isCPass)
                                ? Icons.visibility
                                : Icons.visibility_off,
                            isPas: isCPass,
                            index: 7),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                // setState(() {
                                //   data.isAgree = !data.isAgree;
                                // });
                                data.checkAgree(data.isAgree);
                              },
                              child: Icon(
                                (data.isAgree)
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_outlined,
                                color: Colors.white,
                              ),
                            ),
                            //By checking the box you agree to our Terms and Conditions.
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "  By checking the box you agree to our",
                                    style: GoogleFonts.arimo(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        FocusScope.of(context).unfocus();
                                        navPush(
                                            context: context,
                                            action: ContentScreen(
                                                content:
                                                    content.contentTerms!));
                                      },
                                    text: " Terms ",
                                    style: GoogleFonts.mulish(
                                        color: const Color(0xff02B660),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: "and ",
                                    style: GoogleFonts.arimo(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        FocusScope.of(context).unfocus();
                                        navPush(
                                            context: context,
                                            action: ContentScreen(
                                                content:
                                                    content.contentTerms!));
                                      },
                                    text: "Conditions",
                                    style: GoogleFonts.mulish(
                                        color: const Color(0xff02B660),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: ".",
                                    style: GoogleFonts.arimo(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 40,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: button(label: 'Next', isNext: true, onTap: onTap)),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginScreen();
                    }));
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Already a member?",
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: " Log In",
                      style: GoogleFonts.mulish(
                        color: const Color(0xff02B660),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ])),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget textField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isPas,
    required int index,
  }) =>
      Container(
        child: TextFormField(
          keyboardType: (index == 0)
              ? TextInputType.name
              : (index == 1)
                  ? TextInputType.emailAddress
                  : (index == 2)
                      ? TextInputType.phone
                      : TextInputType.text,
          obscureText: !isPas,
          textCapitalization:
              (index == 0 || index == 3 || index == 4 || index == 5)
                  ? TextCapitalization.words
                  : TextCapitalization.none,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: white,
          ),
          controller: controller,
          inputFormatters: [
            if (index == 0) LengthLimitingTextInputFormatter(50),
            if (index == 1) LengthLimitingTextInputFormatter(50),
            if (index == 2) LengthLimitingTextInputFormatter(10)
          ],
          decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  if (index == 6) {
                    setState(() {
                      isPass = !isPass;
                    });
                  } else if (index == 7) {
                    setState(() {
                      isCPass = !isCPass;
                    });
                  }
                },
                child: Icon(
                  icon,
                  color: white.withOpacity(0.5),
                  size: 20,
                ),
              ),
              hintText: hint,
              hintStyle: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: white.withOpacity(0.5),
              ),
              isDense: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Color(0xffC4C4C4).withOpacity(0.2)),
        ),
      );

  void onTap() async {
    // navPush(context: context, action: VerificationScreen());
    var pro = Provider.of<AuthProvider>(context, listen: false);
    var data = {};
    if (pro.nameController.text.isEmpty) {
      customToast(context: context, msg: 'Name Required', type: 0);
    } else if (pro.emailController.text.isEmpty) {
      customToast(context: context, msg: 'Email ID required', type: 0);
    } else if (!emailExpression.hasMatch(pro.emailController.text)) {
      customToast(context: context, msg: 'Enter valid Email ID', type: 0);
    } else if (pro.phoneController.text.isEmpty) {
      customToast(context: context, msg: 'Phone number required', type: 0);
    } else if (pro.countryController.text.isEmpty) {
      customToast(context: context, msg: 'Country required', type: 0);
    } else if (pro.cityController.text.isEmpty) {
      customToast(context: context, msg: 'City required', type: 0);
    } else if (pro.areaController.text.isEmpty) {
      customToast(context: context, msg: 'Area required', type: 0);
    } else if (pro.passController.text.isEmpty) {
      customToast(context: context, msg: 'Password required', type: 0);
    } else if (pro.passController.text.length < 8) {
      customToast(
          context: context,
          msg: 'Password should be minimum 8 characters',
          type: 0);
    } else if (pro.passController.text != pro.cPassController.text) {
      customToast(context: context, msg: 'Password not match', type: 0);
    } else if (!pro.isAgree) {
      customToast(
          context: context, msg: 'Please accept Terms and Conditions', type: 0);
    } else {
      data = {
        'name': pro.nameController.text,
        'email': pro.emailController.text,
        'contact_number': pro.phoneController.text,
        'password': pro.passController.text,
        'location': pro.address,
        'country': pro.countryController.text,
        'city': pro.cityController.text,
        'area': pro.areaController.text,
        'fcm_id': pro.token,
      };
      pro.signUp(context: context, data: data).then((value) {
        if (pro.isOTP) {
          navPush(context: context, action: VerificationScreen()).then((value) {
            pro.checkOTP();
          });
        }
      });
    }

    log('RegData------------>>>>${pro.isAgree}  $data');
  }
}
