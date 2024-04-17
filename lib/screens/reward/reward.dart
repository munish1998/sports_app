import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:touchmaster/common/cacheImage.dart';
import 'package:touchmaster/providers/profileProvider.dart';

import '../../utils/color.dart';
import '/app_image.dart';
import '/utils/size_extension.dart';

class RewardProcessScreen extends StatefulWidget {
  const RewardProcessScreen({super.key});

  @override
  State<RewardProcessScreen> createState() => _RewardProcessScreenState();
}

class _RewardProcessScreenState extends State<RewardProcessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          )
        ],
        title: Text(
          "Rewards & Progress",
          style: TextStyle(
              letterSpacing: 4,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const AppImage(
              "assets/arrowback.svg",
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          profileSection,
          SizedBox(
            height: 20.h,
          ),
          AppImage(
            "assets/linedivider.svg",
          ),
          rewardSection,
        ],
      ),
    );
  }

  Widget get profileSection =>
      Consumer<ProfileProvider>(builder: (context, data, child) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              cacheImage(
                  image: data.profileModel!.profilePicture,
                  radius: 100,
                  height: 100,
                  width: 100),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.profileModel!.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 27.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Complete Challenges to get\na Green tick",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      });

  Widget get rewardSection =>
      Consumer<ProfileProvider>(builder: (context, data, child) {
        return (data.rewardList.isEmpty)
            ? Container(
                height: 0,
              )
            : Container(
                padding: EdgeInsets.all(20),
                height: 120,
                width: double.infinity,
                alignment: Alignment.center,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.rewardList.length,
                  itemBuilder: (context, index) {
                    var item = data.rewardList[index];
                    return Container(
                      padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(
                          color: primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${item.rewards} Points',
                              style: GoogleFonts.lato(
                                color: white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              )),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            item.title,
                            style: GoogleFonts.lato(
                              color: white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: 30,
                  ),
                ),
              );
      });
}
