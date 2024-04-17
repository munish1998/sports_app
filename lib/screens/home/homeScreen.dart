import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_image.dart';
import '../../common/cacheImage.dart';
import '../../providers/profileProvider.dart';
import '../../utils/color.dart';
import '../connection/usersProfile.dart';
import '../video/videoPlayer.dart';
import '/providers/homeProvider.dart';
import '/providers/userProvider.dart';
import '/screens/suggestions/suggestions.dart';
import '/utils/commonMethod.dart';
import '/utils/constant.dart';
import '/utils/size_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  SharedPreferences? pref;
  double height = 0;
  double width = 0;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    pref = await SharedPreferences.getInstance();

    _homeVideos();
    _getProfile();
  }

  Future<void> _homeVideos() async {
    var pro = Provider.of<HomeProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'limit': '1000',
    };
    pro.getPopularVideos(context: context, data: data);
    pro.getWatchVideos(context: context, data: data);
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
    pro.getProfile(context: context, data: data);
    pro.getRewards(context: context, data: data);
    pro.getProfilePostVideos(context: context, data: dataPost);
    pro.getProfileDraftVideos(context: context, data: dataDraft);
    pro.getProfileSaveVideos(context: context, data: dataSave);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffFFFFFF),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: AppImage(
                            "assets/search.svg",
                          ),
                        ),
                        hintText: "Search",
                        hintStyle: GoogleFonts.mulish(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffFFFFFF).withOpacity(0.5),
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xffC4C4C4).withOpacity(
                          0.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff24D993),
                    ),
                    child: Icon(Icons.search, color: Colors.black, size: 25),
                  )
                ],
              ),
              SizedBox(height: 20),
              popularVideos,
              SizedBox(
                height: 20,
              ),
              watchVideos,
              SizedBox(
                height: 20,
              ),
              suggestionSection,
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get popularVideos =>
      Consumer<HomeProvider>(builder: (context, data, child) {
        return (data.popularVideos.isEmpty)
            ? SizedBox(
                height: 0,
              )
            : Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "POPULAR VIDEOS",
                          style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: "BankGothic",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "SEE ALL",
                            style: GoogleFonts.poppins(
                              color: const Color(0xff24D993),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: data.popularVideos.length > 5
                            ? 5
                            : data.popularVideos.length,
                        itemBuilder: (context, index) {
                          var item = data.popularVideos[index];
                          return InkWell(
                            onTap: () {
                              navPush(
                                  context: context,
                                  action: VideoPlayerScreen(
                                    exercise: data.popularVideos,
                                    index: index,
                                  ));
                            },
                            child: Container(
                              width: 257,
                              height: 160,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(item.thumbnail),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16.r),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      const Color(0xff000000).withOpacity(0.51),
                                      Colors.black.withOpacity(0)
                                    ])),
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.title,
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 1,
                                          ),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.timer_outlined,
                                                color: const Color(0xff192126),
                                                size: 13,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                videoTime(item.videoLength),
                                                style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                        0xff192126)),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        /*Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 1,
                                          ),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.sports_basketball_rounded,
                                                color: const Color(0xff192126),
                                                size: 13,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "All Round Performance",
                                                style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                        0xff192126)),
                                              )
                                            ],
                                          ),
                                        )*/
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                              color: Color(0xff24D993),
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Text(
                                          '${item.totalViews} Views',
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 20,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      });

  Widget get watchVideos =>
      Consumer<HomeProvider>(builder: (context, data, child) {
        return (data.watchVideos.isEmpty)
            ? SizedBox(
                height: 0,
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 3),
                width: width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Watch Videos",
                          style: TextStyle(
                            letterSpacing: 2,
                            fontFamily: "BankGothic",
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            navPush(
                                context: context,
                                action: VideoPlayerScreen(
                                  exercise: data.watchVideos,
                                  index: 0,
                                ));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Watch all",
                                style: GoogleFonts.poppins(
                                  color: primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: height * 0.25,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.watchVideos.length > 5
                            ? 5
                            : data.watchVideos.length,
                        itemBuilder: (context, index) {
                          var item = data.watchVideos[index];
                          return InkWell(
                            onTap: () {
                              navPush(
                                  context: context,
                                  action: VideoPlayerScreen(
                                    exercise: data.watchVideos,
                                    index: index,
                                  ));
                            },
                            child: Container(
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: cacheImageBG(
                                  image: item.thumbnail,
                                  radius: 10,
                                  height: height * 0.23,
                                  width: width * 0.3),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          width: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              );
      });

  Widget get suggestionSection =>
      Consumer<UsersProvider>(builder: (context, data, child) {
        return (data.usersSuggestList.isEmpty)
            ? SizedBox(
                height: 0,
              )
            : Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Suggestions",
                          style: TextStyle(
                            letterSpacing: 2,
                            fontFamily: "BankGothic",
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            navPush(
                                context: context, action: SuggestionScreen());
                          },
                          child: Text(
                            "See all",
                            style: GoogleFonts.poppins(
                              color: primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 170,
                      child: ListView.separated(
                        primary: false,
                        itemCount: (data.usersSuggestList.length > 5)
                            ? 5
                            : data.usersSuggestList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var item = data.usersSuggestList[index];
                          return Container(
                            width: 150,
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xff323232),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    navPush(
                                        context: context,
                                        action: UsersProfileScreen(
                                          profileId: item.userId,
                                          follow: item.follow,
                                        ));
                                  },
                                  child: cacheImages(
                                      image: item.profilePicture,
                                      radius: 100,
                                      height: 85,
                                      width: 85),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (item.follow == 'no') {
                                      var dataSuggest = {
                                        'user_id': pref!
                                                .getString(userIdKey)
                                                .toString() ??
                                            '',
                                        'follow_user_id': item.userId,
                                        'status': 'follow',
                                      };

                                      data.followUnFollow(
                                          context: context, data: dataSuggest);
                                      setState(() {
                                        item.follow = 'yes';
                                        // data.removeUser(item, 1);
                                        data.addUser(item, 2);
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                        color: (item.follow == 'no')
                                            ? primary
                                            : white,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      (item.follow == 'no')
                                          ? "Follow"
                                          : "Following",
                                      style: GoogleFonts.mulish(
                                        color: (item.follow == 'no')
                                            ? white
                                            : primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 20,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      });
}
