import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touchmaster/screens/account/profile1.dart';

import '/app_image.dart';
import '/screens/account/profile.dart';
import '/utils/size_extension.dart';

class OpenMessageScreen extends StatefulWidget {
  const OpenMessageScreen({super.key});

  @override
  State<OpenMessageScreen> createState() => _OpenMessageScreenState();
}

class _OpenMessageScreenState extends State<OpenMessageScreen> {
  List<String> messges = [
    "hi",
    "hello",
    "A dummy note from the person.",
    "i am fine. and you?",
    "not well"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
          },
          child: Text(
            "Shashank  Verma",
            style: TextStyle(
                fontFamily: "BankGothic",
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400),
          ),
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: 80.h,
              left: 16.w,
              right: 16.w,
            ),
            child: ListView.builder(
              itemCount: messges.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              //    reverse: true,

              itemBuilder: (context, index) {
                if (index.isEven) {
                  return ChatBubble(
                    elevation: 0,
                    clipper: ChatBubbleClipper5(
                      type: BubbleType.receiverBubble,
                    ),
                    backGroundColor: const Color(0xff323232),
                    margin: const EdgeInsets.only(top: 20),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.65,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                            ),
                            child: Text(
                              messges.elementAt(index),
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text("10:00 AM",
                              style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff7C7C7C)))
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h) +
                  EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: TextFormField(
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppImage(
                                "assets/emoji.svg",
                                color: const Color(0xffA4A4A4),
                                height: 20.h,
                                width: 10.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              AppImage(
                                "assets/gallery.svg",
                                color: const Color(0xffA4A4A4),
                                height: 20.h,
                                width: 10.w,
                              ),
                            ],
                          ),
                        ),
                        isDense: true,
                        hintText: "Message...",
                        hintStyle: GoogleFonts.inter(
                            color: const Color(0xffA4A4A4),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xff323232))),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xff323232))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xff323232))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xff323232))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xff323232))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xff323232))),
                        fillColor: const Color(0xff323232),
                        filled: true),
                  )),
                  SizedBox(
                    width: 12.w,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xff24D993),
                        shape: BoxShape.circle,
                      ),
                      child: const AppImage("assets/mic.svg"),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Color(0xff24D993),
                        shape: BoxShape.circle,
                      ),
                      child: const AppImage("assets/ic_send.svg"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
