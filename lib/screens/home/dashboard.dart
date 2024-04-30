import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/providers/contactUsProvider.dart';
import 'package:touchmaster/providers/homeProvider.dart';
import 'package:touchmaster/screens/message/inboxMessage.dart';

import '../../common/app_drawer.dart';
import '../../providers/leaderboardProvider.dart';
import '../exercise/levelScreen.dart';
import '../leaderboard/leaderBoard.dart';
import '../notifications/notifications.dart';
import '../practice/practiceScreen.dart';
import '../video/videoRecordingScreen.dart';
import '/app_image.dart';
import '/providers/contentProvider.dart';
import '/providers/levelProvider.dart';
import '/providers/planProvider.dart';
import '/providers/practiceProvider.dart';
import '/providers/profileProvider.dart';
import '/providers/userProvider.dart';
import '/screens/home/homeScreen.dart';
import '/screens/message/messages.dart';
import '/utils/color.dart';
import '/utils/commonMethod.dart';
import '/utils/constant.dart';
import '/utils/size_extension.dart'; // import '/utils/size_extension.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  int currentPage = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? pref;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initFun();
  }

  _initFun() async {
    var contentPro = Provider.of<ContentProvider>(context, listen: false);
    // var profilePro = Provider.of<ProfileProvider>(context, listen: false);
    contentPro.getAbout(context: context);
    contentPro.getPrivacy(context: context);
    contentPro.getTnC(context: context);
    pref = await SharedPreferences.getInstance();
    _homeVideos();
    _getProfile();
    _getLevels();
    _getPlan();
    _getPractice();
    _getAllUsers();
    _getQueries();
    _getLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        drawer: AppDrawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: AppImage(
            "assets/logo.png",
            height: 30,
          ),
          actions: [
            InkWell(
              onTap: () {
                navPush(context: context, action: InboxMessageScreen());
              },
              child: Icon(
                Icons.mark_unread_chat_alt_outlined,
                color: white,
              ),
            ),
            IconButton(
              onPressed: () {
                navPush(context: context, action: NotificationScreen());
              },
              icon: AppImage(
                "assets/notification.svg",
              ),
              // icon: badges.Badge(
              //   badgeStyle: badges.BadgeStyle(
              //     badgeColor: primaryColor,
              //   ),
              //   badgeContent: Text(
              //     '0',
              //     style: GoogleFonts.lato(
              //       color: Colors.black,
              //       fontSize: 13.sp,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              //   child: AppImage(
              //     "assets/notification.svg",
              //   ),
              // ),
            ),
            SizedBox(
              width: 8,
            ),
          ],
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: _getPage(currentPage),
        bottomNavigationBar: bottomNav,
      ),
    );
  }

  Widget get bottomNav => Container(
        color: Colors.black,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: AppImage(
                  "assets/home.svg",
                  height: 27,
                  width: 27,
                  color:
                      currentPage == 0 ? Color(0xff24D993) : Color(0xffBEBEBE),
                ),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: AppImage(
                  "assets/learnIcon.svg",
                  height: 27,
                  width: 27,
                  color:
                      currentPage == 1 ? Color(0xff24D993) : Color(0xffBEBEBE),
                ),
              ),
              label: 'Learn & \nPractice',
            ),
            BottomNavigationBarItem(
                icon: AppImage(
                  "assets/add.svg",
                  height: 27,
                  width: 27,
                  color:
                      currentPage == 2 ? Color(0xff24D993) : Color(0xffBEBEBE),
                ),
                label: ""),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 9),
                child: Icon(
                  Icons.list_alt_rounded,
                  size: 26,
                  color:
                      currentPage == 3 ? Color(0xff24D993) : Color(0xffBEBEBE),
                ),
              ),
              label: 'Levels',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: AppImage(
                  "assets/leaderboard.svg",
                  height: 27,
                  width: 27,
                  color:
                      currentPage == 4 ? Color(0xff24D993) : Color(0xffBEBEBE),
                ),
              ),
              label: 'Leaderboard',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          // Fixed
          selectedItemColor: Color(0xff24D993),
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          selectedLabelStyle: TextStyle(
              letterSpacing: 2,
              fontFamily: "BankGothic",
              color: Color(0xff24D993),
              fontSize: 7,
              fontWeight: FontWeight.w400),
          unselectedLabelStyle: TextStyle(
              letterSpacing: 2,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 7,
              fontWeight: FontWeight.w400),
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(
            size: 22,
            color: Color(0xff24D993),
          ),
          unselectedItemColor: Colors.white,
          currentIndex: currentPage,
          onTap: _onTap,
        ),
      );

  _getPage(int page) {
    if (page == 0) {
      return HomeScreen();
    } else if (page == 1) {
      return PracticeScreen();
      // } else if (page == 2) {
      //   return RecordingScreen();
    } else if (page == 3) {
      return LevelScreen();
    } else if (page == 4) {
      return LeaderBoardScreen();
    }
  }

  _onTap(int index) async {
    if (index != 2) {
      setState(() {
        currentPage = index;
      });
    } else {
      navPush(
          context: context,
          action: VideoRecording(
            isDashboard: true,
          ));
    }
    log('IndexPage------------------------$currentPage   $index');
  }

  Future<void> _getProfile() async {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
    };
    var dataPost = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'status': 'post',
    };
    var dataDraft = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'status': 'draft',
    };
    var dataSave = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'status': 'save',
    };
    var dataCard = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'profile_id': pref!.getString(userIdKey) ?? '',
    };
    pro.getProfile(context: context, data: data);
    pro.getRewards(context: context, data: data);
    pro.getProfilePostVideos(context: context, data: dataPost);
    pro.getProfileDraftVideos(context: context, data: dataDraft);
    pro.getProfileSaveVideos(context: context, data: dataSave);
    pro.getPersonalizeCard(context: context, data: dataCard);
  }

  Future<void> _getPlan() async {
    var pro = Provider.of<PlanProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
    };
    pro.getSubscription(context: context, data: data);
  }

  Future<void> _getQueries() async {
    var pro = Provider.of<ContactUsProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
    };
    pro.getQueries(context: context, data: data);
  }

  Future<void> _getLeaderboard() async {
    var pro = Provider.of<LeaderboardProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'filter_type': 'today', //Filter_type will be ----  today/ week/ month
      'level_id': '0',
    };
    var dataWeek = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'filter_type': 'week', //Filter_type will be ----  today/ week/ month
      'level_id': '0',
    };
    var dataMonth = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'filter_type': 'month', //Filter_type will be ----  today/ week/ month
      'level_id': '0',
    };
    var dataCountry = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'column': 'country',
    };
    var dataCity = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'column': 'city',
    };
    var dataArea = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'column': 'area',
    };
    pro.getLeaderboard(context: context, data: data, isHome: true);
    pro.getLeaderboardWeek(context: context, data: dataWeek, isHome: true);
    pro.getLeaderboardMonth(context: context, data: dataMonth, isHome: true);
    pro.getCountry(context: context, data: dataCountry);
    pro.getCity(context: context, data: dataCity);
    pro.getArea(context: context, data: dataArea);
  }

  Future<void> _homeVideos() async {
    var pro = Provider.of<HomeProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'limit': '1000',
    };
    pro.getPopularVideos(context: context, data: data);
    pro.getWatchVideos(context: context, data: data);
    pro.getNotification(context: context, data: data);
  }

  Future<void> _getPractice() async {
    var pro = Provider.of<PracticeProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey).toString() ?? '',
    };
    pro.getPracticeCategory(context: context, data: data);
  }

  Future<void> _getAllUsers() async {
    var pro = Provider.of<UsersProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey).toString() ?? '',
    };
    pro.getAllUsers(context: context, data: data);
  }

  Future<void> _getLevels() async {
    var pro = Provider.of<LevelProvider>(context, listen: false);
    var userId = pref!.getString(userIdKey) ?? '';
    var data = {'user_id': userId};
    log('userId response of level====>>>>$userId');
    pro.getLevels(context: context, data: data);
  }
}
