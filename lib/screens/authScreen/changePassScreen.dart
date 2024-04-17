import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_image.dart';
import '../../providers/authProvider.dart';
import '../../utils/color.dart';
import '../../utils/commonMethod.dart';
import '../../utils/customLoader.dart';
import '/screens/authScreen/login.dart';
import '/utils/constant.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  bool isPass = false;
  bool isCPass = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    var pro = Provider.of<AuthProvider>(context, listen: false);
    pro.clear();
  }

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
                    height: 40,
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
                    "Change Password".toUpperCase(),
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
                    "Change password to access your account",
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
                        textField(
                            context: context,
                            controller: data.nPassController,
                            hint: 'New Password',
                            icon: (!isPass)
                                ? Icons.visibility
                                : Icons.visibility_off,
                            isPas: isPass,
                            index: 0),
                        SizedBox(
                          height: 20,
                        ),
                        textField(
                            context: context,
                            controller: data.nCPassController,
                            hint: 'Confirm Password',
                            icon: (!isCPass)
                                ? Icons.visibility
                                : Icons.visibility_off,
                            isPas: isCPass,
                            index: 1),
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
                          label: 'CHANGE PASSWORD',
                          isNext: false,
                          onTap: onChange)),

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
          keyboardType: TextInputType.text,
          obscureText: !isPas,
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
                  if (index == 0) {
                    setState(() {
                      isPass = !isPass;
                    });
                  } else if (index == 1) {
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

  Future<void> onChange() async {
    var pro = Provider.of<AuthProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = {};
    if (pro.nPassController.text.isEmpty) {
      customToast(context: context, msg: 'Password required', type: 0);
    } else if (pro.nPassController.text.length < 8) {
      customToast(
          context: context,
          msg: 'Password should be minimum 8 characters',
          type: 0);
    } else if (pro.nPassController.text != pro.nCPassController.text) {
      customToast(context: context, msg: 'Password not match', type: 0);
    } else {
      data = {
        'user_id': pref.getString(userIdKey).toString() ?? '',
        'password': pro.nPassController.text,
      };
      pro.changePass(context: context, data: data).then((value) {
        if (pro.isChange) {
          log('Login Here-------------------- $data');
          pref.clear();
          setState(() {});
          navPushRemove(context: context, action: LoginScreen());
        }
      });
    }
    // log('Login Here-------------------- $data');
  }
}
