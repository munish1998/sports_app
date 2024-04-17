import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../app_image.dart';
import '../providers/authProvider.dart';
import '../providers/contentProvider.dart';
import '../screens/account/profile.dart';
import '../screens/challenges/challengeScreen.dart';
import '/screens/authScreen/changePassScreen.dart';
import '/screens/contact/contactUsScreen.dart';
import '/screens/contentScreen.dart';
import '/screens/plans/planScreen.dart';
import '/screens/reward/reward.dart';
import '/utils/commonMethod.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Consumer<ContentProvider>(builder: (context, content, child) {
        return Column(
          children: [
            SizedBox(height: 90),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: const AppImage(
                "assets/splash.png",
              ),
            ),
            SizedBox(height: 40),
            const Divider(
              color: Color(0xff323232),
            ),
            InkWell(
              onTap: () {
                // log('UserID------>>>  ${preferences!.getString(userIdKey)}');
                // log('UserIDToken------>>>  ${preferences!.getString(accessTokenKey)}');
                navPush(context: context, action: ProfileScreen());
              },
              child: _listContent(
                icon: "assets/ic_profile.svg",
                name: "My Account",
              ),
            ),
            InkWell(
              onTap: () {
                //     drawerstate.currentState!.closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RewardProcessScreen(),
                  ),
                );
              },
              child: _listContent(
                icon: "assets/ic_trophy.svg",
                name: "Rewards & Progress",
              ),
            ),
            InkWell(
              onTap: () {
                //  drawerstate.currentState!.closeDrawer();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlansScreen(),
                  ),
                );
              },
              child: _listContent(
                icon: "assets/logo.png",
                name: "TM Subscription",
              ),
            ),
            InkWell(
              onTap: () {
                //  drawerstate.currentState!.closeDrawer();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengeScreen(),
                  ),
                );
              },
              child: _listContent(
                icon: "assets/logo.png",
                name: "Challenges",
              ),
            ),
            InkWell(
              onTap: () {
                navPush(context: context, action: ChangePassScreen());
              },
              child: _listContent(
                icon: "assets/ic_privacy.svg",
                name: "Change Password",
              ),
            ),
            InkWell(
              onTap: () {
                navPush(
                    context: context,
                    action: ContentScreen(content: content.contentAbout!));
              },
              child: _listContent(
                icon: "assets/ic_terms.svg",
                name: "About us",
              ),
            ),
            InkWell(
              onTap: () {
                navPush(
                    context: context,
                    action: ContentScreen(content: content.contentTerms!));
              },
              child: _listContent(
                icon: "assets/ic_terms.svg",
                name: "Terms of Use",
              ),
            ),
            InkWell(
              onTap: () {
                navPush(
                    context: context,
                    action: ContentScreen(content: content.contentPrivacy!));
              },
              child: _listContent(
                icon: "assets/ic_terms.svg",
                name: "Privacy Policy",
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsScreen(),
                  ),
                );
              },
              child: _listContent(
                icon: "assets/ic_call.svg",
                name: "Contact us",
              ),
            ),
            InkWell(
              onTap: () {
                _exitApp(context);
              },
              child: _listContent(
                icon: "assets/ic_logout.svg",
                name: "Logout",
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "V 1.0.7 - Build: 10",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Future<dynamic> _exitApp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warning!!!!'),
          content: Text('Are you sure want to logout'),
          actions: <Widget>[
            InkWell(
              onTap: () {
                print("you choose no");
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            SizedBox(
              width: 50,
            ),
            InkWell(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .logout(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget _listContent({
    required String icon,
    required String name,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 7),
          Row(
            children: [
              AppImage(
                icon,
                height: 17,
                width: 17,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                name,
                style: TextStyle(
                    letterSpacing: 4,
                    fontFamily: "BankGothic",
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          SizedBox(height: 7),
          const Divider(
            color: Color(0xff323232),
          ),
        ],
      ),
    );
  }
}
