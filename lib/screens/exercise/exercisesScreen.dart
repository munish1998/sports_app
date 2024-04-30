import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/providers/challengesProvider.dart';

import '../../utils/constant.dart';
import '/app_image.dart';
import '/common/cacheImage.dart';
import '/model/exerciseModel.dart';
import '/model/levelModel.dart';
import '/providers/levelProvider.dart';
import '/providers/userProvider.dart';
import '/utils/color.dart';
import '/utils/commonMethod.dart';
import '/utils/size_extension.dart';
import 'exercisePlayerScreen.dart';

class ExercisesScreen extends StatefulWidget {
  final LevelModel? levelItem;

  const ExercisesScreen({super.key, this.levelItem});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  SharedPreferences? pref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.levelItem!.title,
          style: TextStyle(
              letterSpacing: 2,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Consumer<LevelProvider>(builder: (context, data, child) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 229,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(21),
                        child: cacheLevelBG(
                            image: widget.levelItem!.bgImage,
                            radius: 15,
                            height: 250,
                            width: double.infinity),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -30),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    height: 55,
                    decoration: ShapeDecoration(
                      color: grey.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.26,
                          color: Color(
                            0xFFBBF246,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(13.76),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xff24D993),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: AppImage(
                                "assets/ic_timer.svg",
                                height: 13,
                                width: 29,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${widget.levelItem!.duration} ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -20),
                  child: Column(
                    children: [
                      Text(
                        'LEVEL ${widget.levelItem!.exercises}',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.levelItem!.description,
                        style: GoogleFonts.lato(
                            color: const Color(0xffFFFFFF).withOpacity(0.5),
                            fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.exerciseList.length,
                        itemBuilder: (context, index) {
                          var item = data.exerciseList[index];
                          return exerciseItem(item);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget exerciseItem(ExerciseModel item) => Container(
        child: InkWell(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseContentScreen(exercise: item),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
                color: const Color(0xff323232),
                borderRadius: BorderRadius.circular(13)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: cacheImages(
                      image: item.bgImage, radius: 10, height: 55, width: 55),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.lato(
                        color: white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Text(
                    //   "30:00",
                    //   style: GoogleFonts.lato(
                    //     color: white.withOpacity(0.5),
                    //     fontSize: 11,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // )
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    var pro =
                        Provider.of<UsersProvider>(context, listen: false);
                    if (pro.usersFollowList.isNotEmpty) {
                      challengeDialog(context: context, exerciseId: item.id);
                    } else {
                      commonAlert(context, 'You have no any connection yet');
                    }
                  },
                  icon: Icon(
                    Icons.people_outline,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void challengeDialog(
      {required BuildContext context, required String exerciseId}) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Consumer<UsersProvider>(builder: (context, data, child) {
              return Container(
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 20) +
                    EdgeInsets.only(top: 300, bottom: 100),
                decoration: BoxDecoration(
                    color: Color(0xff323232),
                    borderRadius: BorderRadius.circular(19)),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    children: [
                      // bottomz image
                      ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(16),
                        itemCount: data.usersFollowList.length,
                        itemBuilder: (context, index) {
                          var item = data.usersFollowList[index];
                          return Container(
                            child: Row(
                              children: [
                                cacheImages(
                                    image: item.profilePicture,
                                    radius: 50,
                                    height: 45,
                                    width: 45),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    color: white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    onChallenge(
                                        challengeId: item.userId,
                                        exerciseId: exerciseId);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: 10,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                        color: grey,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      "Challenge",
                                      style: GoogleFonts.mulish(
                                        color: white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                            height: 15,
                            child: Divider(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
          });
        });
  }

  Future<void> onChallenge(
      {required String challengeId, required String exerciseId}) async {
    var pro = Provider.of<ChallengeProvider>(context, listen: false);

    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
      'challenger_id': challengeId,
      'exercise_id': exerciseId,
    };

    pro.challengeUser(context: context, data: data).then((value) {
      if (pro.isChallenged) {
        navPop(context: context);
      }
      commonAlert(context, pro.msg);
      log('ChaleengeData --------${pro.msg}    ${pro.isChallenged}');
    });
  }
}
