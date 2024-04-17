import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/color.dart';
import '/app_image.dart';
import '/common/app_colors.dart';
import '/model/planModel.dart';
import '/providers/planProvider.dart';
import '/screens/notifications/notifications.dart';
import '/utils/constant.dart';
import '/utils/size_extension.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  double height = 0;
  double width = 0;

  int initIndex = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: AppImage(
          "assets/logo.png",
          height: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            icon: badges.Badge(
              badgeStyle: badges.BadgeStyle(
                badgeColor: primaryColor,
              ),
              badgeContent: Text(
                '0',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const AppImage(
                "assets/notification.svg",
              ),
            ),
          )
        ],
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
