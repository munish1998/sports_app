import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:touchmaster/providers/homeProvider.dart';

import '../../utils/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: TextStyle(
              letterSpacing: 2,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Consumer<HomeProvider>(builder: (context, data, child) {
          return ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              shrinkWrap: true,
              itemCount: data.notifyList.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var item = data.notifyList[index];
                return InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: grey,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff000000).withOpacity(0.06),
                          spreadRadius: 0,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          item.description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item.dateTime,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        }),
      ),
      // bottomNavigationBar:,
    );
  }
}

class NotificationContant {
  final String title;
  final String subtitle;
  final String image;

  NotificationContant({
    required this.image,
    required this.subtitle,
    required this.title,
  });
}
