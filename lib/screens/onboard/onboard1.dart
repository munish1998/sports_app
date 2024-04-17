import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding/onboarding.dart';

import '../../utils/constant.dart';
import '../authScreen/login.dart';
import '/app_image.dart';
import '/main.dart';
import '/utils/size_extension.dart';

class FirstOnboard extends StatefulWidget {
  const FirstOnboard({super.key});

  @override
  State<FirstOnboard> createState() => _FirstOnboardState();
}

class _FirstOnboardState extends State<FirstOnboard> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            image: AssetImage(
              "assets/gradient.png",
            ),
          ),
        ),
        child: Onboarding(
          pages: [
            PageModel(
              widget: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 150.h,
                    left: 10.w,
                    right: 20.w,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          AppImage(
                            'assets/onboard1.png',
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 60.h,
                              ),
                              child: const AppImage(
                                "assets/logo.png",
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        'Welcome  to   Touch   Master',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "BankGothic",
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w200,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Master the ball, master the game in the comfort of your own home',
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PageModel(
              widget: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 45.h,
                    left: 10.w,
                    right: 20.w,
                  ),
                  child: Column(
                    children: [
                      AppImage(
                        'assets/onboard2.png',
                        height: 400,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Unlock   your potential'.toUpperCase(),
                        style: TextStyle(
                          fontFamily: "BankGothic",
                          color: Colors.white,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Through full access to our training programmes',
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PageModel(
              widget: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 35.h,
                    left: 10.w,
                    right: 20.w,
                  ),
                  child: Column(
                    children: [
                      AppImage(
                        'assets/onboard3.png',
                        height: 400,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Create   and Upload'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36.sp,
                          fontFamily: "BankGothic",
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Your own ball mastery sequences and share with others',
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Icon(Icons.,),
            PageModel(
              widget: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 45.h,
                    left: 10.w,
                    right: 20.w,
                  ),
                  child: Column(
                    children: [
                      AppImage(
                        'assets/onboard4.png',
                        height: 400,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Monitor   your Progress'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "BankGothic",
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Compare your results on our touch master Leaderboards',
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          onPageChange: (int pageIndex) {
            index = pageIndex;
          },
          startPageIndex: index,
          footerBuilder: (context, dragDistance, pagesLength, setIndex) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 60.h,
                  right: 20.w,
                  left: 16.w,
                ),
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIndicator(
                        netDragPercent: dragDistance,
                        pagesLength: pagesLength,
                        indicator: Indicator(
                          closedIndicator: const ClosedIndicator(
                              color: Colors.white, borderWidth: 6),
                          activeIndicator: const ActiveIndicator(
                              color: Colors.black, borderWidth: 6),
                          indicatorDesign: IndicatorDesign.line(
                            lineDesign: LineDesign(
                              lineType: DesignType.line_uniform,
                            ),
                          ),
                        ),
                      ),
                      index == pagesLength - 1
                          ? InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                                preferences!.setBool(isInitKey, true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  "Get Started",
                                  style: GoogleFonts.mulish(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                if (index == 0) {
                                  setState(() {
                                    index = 1;
                                  });
                                } else if (index == 1) {
                                  setState(() {
                                    index = 2;
                                  });
                                } else if (index == 2) {
                                  setState(() {
                                    index = 3;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(
                                  16.r,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
