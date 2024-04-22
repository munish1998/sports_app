import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/personalizeModel.dart';

import '../../providers/profileProvider.dart';
import '../../utils/color.dart';
import '../../utils/customLoader.dart';
import '../connection/connections.dart';
import '../suggestions/suggestions.dart';
import '../video/videoPlayer.dart';
import '/app_image.dart';
import '/common/cacheImage.dart';
import '/model/profileVideoModel.dart';
import '/providers/userProvider.dart';
import '/utils/commonMethod.dart';
import '/utils/constant.dart';
import '/utils/size_extension.dart';
import 'editProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  File? _selectedImage;
  File? _selectedCardImage;
  SharedPreferences? pref;

  double height = 0;
  double width = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initFun();
  }

  _initFun() async {
    pref = await SharedPreferences.getInstance();
    getProfile();
  }

  getProfile() async {
    var data = {'user_id': pref!.getString(userIdKey).toString() ?? ''};
    log('UserFound---------->>>> $data');
    await Provider.of<ProfileProvider>(context, listen: false)
        .getProfile(context: context, data: data);
  }

  getCard() async {
    var dataCard = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'profile_id': pref!.getString(userIdKey) ?? '',
    };
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    pro.getPersonalizeCard(context: context, data: dataCard);
    pro.setFalse();
    setState(() {
      _selectedCardImage = null;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Consumer<ProfileProvider>(builder: (context, data, child) {
            return (data.profileModel == null)
                ? Center(
                    child: StaggeredDotsWave(),
                  )
                : ListView(
                    children: [
                      profileSection,
                      cardSection,
                      postSection,
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget get cardSection =>
      Consumer<ProfileProvider>(builder: (context, data, child) {
        // var item = data.personalizeCards.length;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (data.personalizeCards.isEmpty)
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Center(
                        child: Container(
                          height: 365,
                          width: MediaQuery.sizeOf(context).width,
                          alignment: Alignment.center,
                          child: Center(
                            child: CardSwiper(
                                padding: EdgeInsets.zero,
                                direction: CardSwiperDirection.right,
                                numberOfCardsDisplayed:
                                    (data.personalizeCards.length > 1) ? 2 : 1,
                                cardsCount: data.personalizeCards.length,
                                cardBuilder: (context, index, o, i) {
                                  var item = data.personalizeCards[index];
                                  return InkWell(
                                    onTap: () {
                                      // showCardDetail(
                                      //     context: context, item: item);
                                    },
                                    child: cardWidget(item),
                                  );
                                }),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.w),
                        child: const AppImage("assets/linedivider.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          "Personalized Card",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.w),
                        child: const AppImage("assets/linedivider.svg"),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
          ],
        );
      });

  Widget cardWidget(PersonalizeModel item) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 375,
            width: 275,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 345,
                  width: 275,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 2, color: primary),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          (_selectedCardImage == null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: cacheImageBG(
                                      image: item.image ?? '',
                                      radius: 0,
                                      height: 170,
                                      width: 275),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: Container(
                                    height: 170,
                                    width: 275,
                                    decoration: BoxDecoration(
                                        // border:
                                        //     Border.all(color: grey.withOpacity(0.5)),
                                        // borderRadius: BorderRadius.circular(100),
                                        image: DecorationImage(
                                      image: FileImage(
                                          File(_selectedCardImage!.path)),
                                    )),
                                  ),
                                ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: -8,
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              height: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage(
                                        "assets/ic_card1.png",
                                      ))),
                              child: Center(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                      letterSpacing: 4,
                                      fontFamily: "BankGothic",
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 10,
                            child: AppImage(
                              "https://upload.wikimedia.org/wikipedia/en/4/41/Flag_of_India.svg",
                              height: 20,
                              width: 20,
                            ),
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 171,
                            width: 275,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    "assets/pCard.png",
                                  ),
                                )),
                          ),
                          Positioned(
                              top: 15,
                              right: 1,
                              left: 1,
                              child: Center(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                      letterSpacing: 4,
                                      fontFamily: "BankGothic",
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              )),
                          Positioned(
                              top: 50,
                              right: 1,
                              left: 1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: AppImage("assets/linedivider.svg"),
                              )),
                          Positioned(
                              top: 70,
                              left: 1,
                              right: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        item.rank,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(
                                        "LEADERBOARD RANK",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 6,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                // height: 30.h,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      topRight: Radius.circular(25)),
                                ),
                                child: Center(
                                  child: Text(
                                    item.completionDate,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  Widget get profileSection => Consumer2<ProfileProvider, UsersProvider>(
          builder: (context, data, userData, child) {
        return Column(
          children: [
            Container(
              // padding: EdgeInsets.only(top: 55.h, left: 20.w),
              width: double.infinity,
              height: width * 0.8,

              child: Stack(
                children: [
                  Container(
                    height: width * 0.6,
                    child: Stack(
                      children: [
                        (_selectedImage == null)
                            ? cacheImageBG(
                                image: data.profileModel!.bgProfile ?? '',
                                radius: 0,
                                height: width,
                                width: width)
                            : Container(
                                height: width,
                                width: width,
                                decoration: BoxDecoration(
                                    // border:
                                    //     Border.all(color: grey.withOpacity(0.5)),
                                    // borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                  image: FileImage(File(_selectedImage!.path)),
                                )),
                              ),
                        Positioned(
                          bottom: 15,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              getPicker(ImageSource.gallery);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: grey.withOpacity(0.8),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    100,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.camera_alt,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 25,
                          left: 15,
                          child: InkWell(
                            onTap: () {
                              navPop(context: context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: grey.withOpacity(0.2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    100,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cacheImage(
                            image: data.profileModel!.profilePicture,
                            radius: 100,
                            height: height * 0.15,
                            width: height * 0.15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.profileModel!.name,
                  style: TextStyle(
                      letterSpacing: 4,
                      fontFamily: "BankGothic",
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 10,
                ),
                if (data.profileModel!.type == 'influencer')
                  AppImage(
                    "assets/ic_tick.svg",
                  ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              data.profileModel!.location,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () async {
                if (userData.usersFollowList.isNotEmpty) {
                  navPush(context: context, action: ConnectionsScreen())
                      .then((value) {
                    // getUsers();
                  });
                } else {
                  customToast(
                      context: context, msg: 'No connection found!', type: 0);
                }
              },
              child: Column(
                children: [
                  Text(
                    '${userData.usersFollowList.length}',
                    style: GoogleFonts.poppins(
                      color: primary,
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Connections",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonPro(
                    title: 'Edit Profile',
                    onTap: () {
                      navPush(context: context, action: EditProfile());
                    }),
                SizedBox(
                  width: 20,
                ),
                buttonPro(
                    title: 'Add Friends',
                    onTap: () {
                      navPush(context: context, action: SuggestionScreen());
                    }),
              ],
            ),
            SizedBox(
              height: 50,
            ),
          ],
        );
      });

  Widget
      get cardSection1 =>
          Consumer<ProfileProvider>(builder: (context, data, child) {
            return Column(
              children: [
                SizedBox(
                  height: 365,
                  child: CardSwiper(
                      padding: EdgeInsets.zero,
                      direction: CardSwiperDirection.right,
                      cardsCount: 10,
                      cardBuilder: (context, index, o, i) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: SizedBox(
                                      height: 403.h,
                                      child: StatefulBuilder(
                                          builder: (context, _) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: PageView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: 5,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    cardDesign(),
                                                                    SizedBox(
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              60.w),
                                                                      child: const AppImage(
                                                                          "assets/linedivider.svg"),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            10,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        "Add Information",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              15.sp,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              60.w),
                                                                      child: const AppImage(
                                                                          "assets/linedivider.svg"),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              20.w),
                                                                      padding: EdgeInsets
                                                                          .all(12
                                                                              .r),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xff323232),
                                                                        borderRadius:
                                                                            BorderRadius.circular(19),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          titlesubtitle(
                                                                            title:
                                                                                "Name",
                                                                            subtitle:
                                                                                "Shasank Verma",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.h,
                                                                          ),
                                                                          titlesubtitle(
                                                                            title:
                                                                                "Age",
                                                                            subtitle:
                                                                                "26",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.h,
                                                                          ),
                                                                          titlesubtitle(
                                                                            title:
                                                                                "Nationality",
                                                                            subtitle:
                                                                                "India",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.h,
                                                                          ),
                                                                          titlesubtitle(
                                                                            title:
                                                                                "Membership",
                                                                            subtitle:
                                                                                "Pro Member",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.h,
                                                                          ),
                                                                          titlesubtitle(
                                                                            title:
                                                                                "Level",
                                                                            subtitle:
                                                                                "1",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.h,
                                                                          ),
                                                                          titlesubtitle(
                                                                            title:
                                                                                "Training Streak",
                                                                            subtitle:
                                                                                "259",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.h,
                                                                          ),
                                                                          titlesubtitle(
                                                                            title:
                                                                                "Leaderbord Rank",
                                                                            subtitle:
                                                                                "25",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.h,
                                                                          ),
                                                                          titlesubtitle(
                                                                            title:
                                                                                "Date",
                                                                            subtitle:
                                                                                "3 Aug,23",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.h,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Image",
                                                                                style: GoogleFonts.poppins(
                                                                                  color: Colors.white,
                                                                                  fontSize: 12.sp,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: 130.w,
                                                                                    padding: const EdgeInsets.all(8),
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(
                                                                                        color: const Color(0xff555555),
                                                                                      ),
                                                                                      borderRadius: BorderRadius.circular(2),
                                                                                    ),
                                                                                    child: Text(
                                                                                      "Potrait.jpg",
                                                                                      textAlign: TextAlign.end,
                                                                                      style: GoogleFonts.poppins(
                                                                                        color: Colors.white,
                                                                                        fontSize: 10.sp,
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    padding: const EdgeInsets.all(8),
                                                                                    decoration: BoxDecoration(
                                                                                      color: const Color(0xff555555),
                                                                                      borderRadius: BorderRadius.circular(2),
                                                                                    ),
                                                                                    child: Text(
                                                                                      "Browse Files",
                                                                                      style: GoogleFonts.poppins(
                                                                                        color: Colors.white,
                                                                                        fontSize: 10.sp,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: SizedBox(
                                                        width: 380.w,
                                                        child: cardDesign(),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60.w),
                                              child: const AppImage(
                                                  "assets/linedivider.svg"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              child: Text(
                                                "Personalized Card",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60.w),
                                              child: const AppImage(
                                                  "assets/linedivider.svg"),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  );
                                });
                          },
                          child: cardDesign(),
                        );
                      }),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: const AppImage("assets/linedivider.svg"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    "Personalized Card",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: const AppImage("assets/linedivider.svg"),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            );
          });

  Widget get postSection =>
      Consumer<ProfileProvider>(builder: (context, data, child) {
        return Container(
          height: height * 0.9,
          child: Column(
            children: [
              Container(
                height: 50.h,
                margin: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: const Color(0xff323232), width: 2),
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          surfaceVariant: Colors.transparent,
                        ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorPadding: const EdgeInsets.all(4),
                    indicatorSize: TabBarIndicatorSize.tab,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: const Color(0xff24D993),
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    labelStyle: GoogleFonts.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: GoogleFonts.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: [
                      Tab(
                        text: 'Post',
                      ),
                      Tab(
                        text: 'Draft',
                      ),
                      Tab(
                        text: 'Save',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  GridView.builder(
                    itemCount: data.profilePostVideos.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 12,
                      crossAxisCount: 3,
                      childAspectRatio: 1.4 / 2,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      var item = data.profilePostVideos[index];
                      return videoItem(
                          item: item,
                          videoList: data.profilePostVideos,
                          index: index);
                    },
                  ),
                  GridView.builder(
                    itemCount: data.profileDraftVideos.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 12,
                      crossAxisCount: 3,
                      childAspectRatio: 1.4 / 2,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      var item = data.profileDraftVideos[index];
                      return videoItem(
                          item: item,
                          videoList: data.profileDraftVideos,
                          index: index);
                    },
                  ),
                  GridView.builder(
                    itemCount: data.profileSaveVideos.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 12,
                      crossAxisCount: 3,
                      childAspectRatio: 1.4 / 2,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      var item = data.profileSaveVideos[index];
                      return videoItem(
                          item: item,
                          videoList: data.profileSaveVideos,
                          index: index);
                    },
                  ),
                ],
              ))
            ],
          ),
        );
      });

  Widget buttonPro({required String title, required Function() onTap}) =>
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          decoration: BoxDecoration(
              color: const Color(0xff24D993),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            title,
            style: GoogleFonts.mulish(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  Widget titlesubtitle({required String title, required String subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          width: 130.w,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xff555555),
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            subtitle,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  Widget cardDesign() {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          image: const DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(
              "assets/ic_card2.png",
            ),
          ),
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffffffff),
          border: Border.all(
            color: const Color(0xff24D993),
            width: 1.5,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 60,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/ic_card.png",
                ),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: Offset(100, -5),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 10.h,
                      ),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                        "assets/ic_card_4.png",
                      ))),
                      child: Center(
                        child: Text(
                          "      PRO MEMBER",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xff7971B5), Color(0xff202243)],
                      ),
                    ),
                    child: Text(
                      "26",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: AppImage(
                      "https://upload.wikimedia.org/wikipedia/en/4/41/Flag_of_India.svg",
                      height: 20.h,
                      width: 20.w,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -35),
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: 40.h,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "assets/ic_card1.png",
                            ))),
                    child: Center(
                      child: Text(
                        "LEVEL 1",
                        style: TextStyle(
                            letterSpacing: 4,
                            fontFamily: "BankGothic",
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 10),
                    child: Text(
                      '',
                      style: TextStyle(
                          letterSpacing: 4,
                          fontFamily: "BankGothic",
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 20),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const AppImage("assets/linedivider.svg"),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "250",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "TRAINING STREAK",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 6.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "25th",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "LEADERBOARD RANK",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 6.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-17, 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 10.h,
                          ),
                          // height: 30.h,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                            "assets/ic_card3.png",
                          ))),
                          child: Center(
                            child: Text(
                              "3 AUG ‘23",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget videoItem(
          {required ProfileVideoModel item,
          required List<ProfileVideoModel> videoList,
          required int index}) =>
      Container(
        child: InkWell(
          onTap: () {
            navPush(
                context: context,
                action: VideoPlayerScreen(
                  exercise: videoList,
                  index: index,
                ));
          },
          child: cacheImageBG(
              image: item.thumbnail,
              radius: 10,
              height: width * 0.5,
              width: width * 0.33),
        ),
      );

  Future<void> getPicker(ImageSource imageSource) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: imageSource,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      // _selectedImage = File(image!.path);

      _imageCropper(File(image!.path));
    } on CameraException catch (e) {
      // TODO
      customToast(context: context, msg: e.description.toString(), type: 0);
    }
  }

  Future<void> _imageCropper(File photo) async {
    CroppedFile? cropPhoto = await ImageCropper().cropImage(
      sourcePath: photo.path,
      maxWidth: 1024,
      maxHeight: 1024,
      compressFormat: ImageCompressFormat.png,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3
      ],
    );
    setState(() {
      if (cropPhoto != null) {
        _selectedImage = File(cropPhoto.path);
        if (_selectedImage != null) {
          Provider.of<ProfileProvider>(context, listen: false)
              .editProfileBG(context: context, filePath: _selectedImage!.path);
        } else {
          commonToast(msg: 'Please select background image', color: red);
        }
        log('==>>>${_selectedImage!.path}');
        log('==>>>${_selectedImage!.path.toString().split('/').last.replaceAll('\'', '')}');
      }
    });
  }
}
