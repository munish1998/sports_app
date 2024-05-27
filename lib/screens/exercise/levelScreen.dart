import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/screens/exercise/exercisechallengeScreen.dart';
import 'package:touchmaster/screens/exercise/exercisesScreen.dart';
import '../../app_image.dart';
import '../../model/levelModel.dart';
import '../../utils/color.dart';
import '/common/cacheImage.dart';
import '/providers/levelProvider.dart';
import '/utils/commonMethod.dart';
import '/utils/constant.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({
    super.key,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double height = 0;
  double width = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the lock status of all levels except the first one
    Provider.of<LevelProvider>(context, listen: false).initAllLevels();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Consumer<LevelProvider>(builder: (context, data, child) {
            return Column(
              children: [
                SizedBox(height: 20),
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
                        child: const AppImage(
                          "assets/ic_demo.png",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -30),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 60,
                    decoration: ShapeDecoration(
                      color: const Color(0x4C192126),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 0.26,
                          color: Color(
                            0xFFBBF246,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(13.76),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                            SizedBox(width: 10),
                            Text(
                              "30 mins",
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
                        "Off Season Programme",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "The lower abdomen and hips are the most difficult areas of the body to reduce when we are on a diet. Even so, in this area, especially the legs as a whole, you can reduce weight even if you don't use tools.",
                        style: GoogleFonts.lato(
                          color: const Color(0xffFFFFFF).withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.levelList.length,
                        itemBuilder: (context, index) {
                          var item = data.levelList[index];
                          // Determine if the level should be locked
                          bool isLocked = index != 0 &&
                              data.levelList[index - 1].lockstatus == 'locked';
                          return levelItem(item, isLocked);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
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

  Widget levelItem(LevelModel item, bool isLocked) => Container(
        child: InkWell(
          onTap: () async {
            if (!isLocked) {
              var pro = Provider.of<LevelProvider>(context, listen: false);
              SharedPreferences pref = await SharedPreferences.getInstance();
              var data = {
                'user_id': pref.getString(userIdKey).toString(),
                'level_id': item.id,
              };
              log('response of level data ====>>>$data');
              pro.getExercises(context: context, data: data).then((value) {
                if (pro.isExercise) {
                  navPush(
                    context: context,
                    action: ExercisesScreen(levelItem: item),
                  );
                }
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "This level is locked. Complete previous levels first."),
                ),
              );
            }
          },
          child: Stack(
            children: [
              cacheImageBG(
                image: item.bgImage,
                radius: 10,
                height: width * 0.5,
                width: width,
              ),
              Positioned(
                bottom: 0.1,
                child: Container(
                  height: 65,
                  width: width - 32,
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    backgroundBlendMode: BlendMode.srcOver,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.title,
                    style: TextStyle(
                      letterSpacing: 2,
                      fontFamily: "BankGothic",
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              if (isLocked)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(Icons.lock, color: Colors.white, size: 30),
                ),
            ],
          ),
        ),
      );
}
