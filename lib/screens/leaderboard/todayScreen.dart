import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_image.dart';
import '../../common/cacheImage.dart';
import '../../model/leaderboardModel.dart';
import '../../providers/leaderboardProvider.dart';
import '../../providers/levelProvider.dart';
import '../../utils/color.dart';
import '../../utils/commonMethod.dart';
import '../../utils/constant.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  SharedPreferences? pref;
  final GlobalKey _menuKey = GlobalKey();
  String selectedItem = 'Overall';
  String country = 'Country';
  String city = 'City';
  String area = 'Area';

  double height = 0;
  double width = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    pref = await SharedPreferences.getInstance();
    var pro = Provider.of<LeaderboardProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'filter_type': 'today', //Filter_type will be ----  today/ week/ month
      'level_id': '0',
    };
    pro.getLeaderboard(context: context, data: data, isHome: false);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    return Container(
      child: tabviewToday,
    );
  }

  Widget get tabviewToday => SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Consumer<LeaderboardProvider>(builder: (context, data, child) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              /*Container(
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "#12",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "You are doing better than 50% of other\nusers!",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),*/
              SizedBox(
                height: 10,
              ),
              levelSection,
              topLeaders(data.leaderTop),
              if (data.leaderTop.isNotEmpty) AppImage("assets/linedivider.svg"),
              if (data.leaderTop.isNotEmpty) locationSection,
              if (data.leaderTop.isNotEmpty) AppImage("assets/linedivider.svg"),
              SizedBox(
                height: 20,
              ),
              listLeaders(data.leaderboardList),
            ],
          );
        }),
      );

  Widget get locationSection =>
      Consumer<LeaderboardProvider>(builder: (context, data, child) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  showAreaSheet(context: context);
                },
                child: Row(
                  children: [
                    Text(
                      area,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showCitySheet(context: context);
                },
                child: Row(
                  children: [
                    Text(
                      city,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showCountrySheet(context: context);
                },
                child: Row(
                  children: [
                    Text(
                      country,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });

  Widget get levelSection =>
      Consumer<LevelProvider>(builder: (context, data, child) {
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<PopUpModel>(
              offset: Offset(-12, 50),
              key: _menuKey,
              // initialValue: selectedItem,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),

              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xff323232),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffFFFFFF).withOpacity(0.25),
                        spreadRadius: 0,
                        blurStyle: BlurStyle.inner,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: const Color(0xffFFFFFF).withOpacity(0.25),
                        spreadRadius: 0,
                        blurStyle: BlurStyle.inner,
                        blurRadius: 1,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '  $selectedItem',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.white,
                      )
                    ],
                  )),
              itemBuilder: (BuildContext ctx) {
                return data.listLevel;
              },
              onSelected: (PopUpModel value) {
                log('Selected Value here:=====>  $value');
                onSelectLevel(value.value);
                setState(() {
                  selectedItem = value.value == '0' ? 'Overall' : value.title;
                });
              },
            ),
          ),
        );
      });

  Widget topLeaders(List<LeaderboardModel> topList) => Container(
        child: (topList.isEmpty)
            ? SizedBox(
                height: 250,
                width: 250,
                child: Center(
                  child: Text(
                    'No data found!',
                    style:
                        TextStyle(color: white.withOpacity(0.3), fontSize: 18),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (topList.length > 1)
                      ? Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xffF4F4F4),
                                  width: 3.7,
                                ),
                              ),
                              child: cacheImages(
                                  image: topList[1].profileImage,
                                  radius: 100,
                                  height: 64,
                                  width: 64),
                            ),
                            Text(
                              topList[1].name,
                              style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            Text(
                              topList[1].title,
                              style: GoogleFonts.lato(
                                color: const Color(0xffFFFFFF).withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: 0,
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, 10),
                          child: AppImage(
                            "assets/ic_crown.png",
                            height: 73,
                            width: 73,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xffFFCA28),
                              width: 3.7,
                            ),
                          ),
                          child: cacheImages(
                              image: topList[0].profileImage,
                              radius: 100,
                              height: 91,
                              width: 91),
                        ),
                        Text(
                          topList[0].name,
                          style: GoogleFonts.lato(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Text(
                          topList[0].title,
                          style: GoogleFonts.lato(
                            color: Color(0xffFFFFFF).withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  (topList.length > 2)
                      ? Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xffFF8228),
                                  width: 3.7,
                                ),
                              ),
                              child: cacheImages(
                                  image: topList[2].profileImage,
                                  radius: 100,
                                  height: 64,
                                  width: 64),
                            ),
                            Text(
                              topList[2].name,
                              style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            Text(
                              topList[2].title,
                              style: GoogleFonts.lato(
                                color: const Color(0xffFFFFFF).withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 0,
                        )
                ],
              ),
      );

  Widget listLeaders(List<LeaderboardModel> leaderList) => Container(
        child: (leaderList.isEmpty)
            ? SizedBox(
                height: 0,
              )
            : ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: leaderList.length,
                itemBuilder: (context, index) {
                  var item = leaderList[index];
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? const Color(0xffFFCA28)
                          : index == 1
                              ? Colors.white
                              : index == 2
                                  ? const Color(0xffFF8228)
                                  : const Color(0xff323232),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${index + 3}',
                          style: GoogleFonts.nunito(
                            color: index < 3 ? Colors.black : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        cacheImages(
                            image: item.profileImage,
                            radius: 100,
                            height: 45,
                            width: 45),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          item.name,
                          style: GoogleFonts.nunito(
                            color: index < 3 ? Colors.black : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              // pts.
                              text: item.reward,
                              style: GoogleFonts.nunito(
                                  color: index < 3
                                      ? Colors.black
                                      : Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          TextSpan(
                              // pts.
                              text: "pts.",
                              style: GoogleFonts.nunito(
                                  color: index < 3
                                      ? Colors.black
                                      : Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400))
                        ]))
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 20,
                  );
                },
              ),
      );

  Future<void> showCountrySheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Consumer<LeaderboardProvider>(
                builder: (context, data, child) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 400,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Country',
                              style: TextStyle(color: white, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                navPop(context: context);
                              },
                              child: Icon(
                                Icons.clear,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        height: 320,
                        child: ListView.separated(
                          itemCount: data.country.length,
                          itemBuilder: (context, index) {
                            var item = data.country[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  country = item;
                                });
                                navPop(context: context);
                                onSelectLocation('country', country);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: grey,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  capitalize(item),
                                  style: TextStyle(color: white),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            });
          });
        });
  }

  Future<void> showCitySheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Consumer<LeaderboardProvider>(
                builder: (context, data, child) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 400,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Country',
                              style: TextStyle(color: white, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                navPop(context: context);
                              },
                              child: Icon(
                                Icons.clear,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        height: 320,
                        child: ListView.separated(
                          itemCount: data.city.length,
                          itemBuilder: (context, index) {
                            var item = data.city[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  city = item;
                                });
                                navPop(context: context);
                                onSelectLocation('city', city);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: grey,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  capitalize(item),
                                  style: TextStyle(color: white),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            });
          });
        });
  }

  Future<void> showAreaSheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Consumer<LeaderboardProvider>(
                builder: (context, data, child) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 400,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Area',
                              style: TextStyle(color: white, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                navPop(context: context);
                              },
                              child: Icon(
                                Icons.clear,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        height: 320,
                        child: ListView.separated(
                          itemCount: data.area.length,
                          itemBuilder: (context, index) {
                            var item = data.area[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  area = item;
                                });
                                log('message=----------->>>  $area');

                                navPop(context: context);
                                onSelectLocation('area', area);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: grey,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  capitalize(item),
                                  style: TextStyle(color: white),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            });
          });
        });
  }

  void onSelectLocation(String type, String location) async {
    var pro = Provider.of<LeaderboardProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'filter_type': 'month', //Filter_type will be ----  today/ week/ month
      'level_id': '0',
      type: location,
    };
    pro.getLeaderboard(context: context, data: data, isHome: false);
  }

  void onSelectLevel(String level) async {
    var pro = Provider.of<LeaderboardProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'filter_type': 'month', //Filter_type will be ----  today/ week/ month
      'level_id': level,
      'area': area != 'Area' ? area : '',
      'city': city != 'City' ? city : '',
      'country': country != 'Country' ? country : '',
    };
    pro.getLeaderboard(context: context, data: data, isHome: false);
  }
}
