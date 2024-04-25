// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:touchmaster/model/mesageModel.dart';
// import 'package:touchmaster/providers/messageProviders.dart';

// import 'package:touchmaster/utils/constant.dart';
// import 'package:touchmaster/utils/size_extension.dart';

// class OpenMessageScreen extends StatefulWidget {
//   const OpenMessageScreen({Key? key}) : super(key: key);

//   @override
//   State<OpenMessageScreen> createState() => _OpenMessageScreenState();
// }

// class _OpenMessageScreenState extends State<OpenMessageScreen> {
//   SharedPreferences? pref;
//   @override
//   void initState() {
//     super.initState();
//     initFun();
//   }

//   initFun() async {
//     var pro = Provider.of<MessageProvider>(context, listen: false);
//     await pro.getChat(context: context, data: {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text('Chat History'),
//       ),
//       body: Consumer<MessageProvider>(
//         builder: (context, messageProvider, _) {
//           if (messageProvider.chatList.isEmpty) {
//             return Center(
//               child: Text(
//                 'No chat history found',
//                 style: TextStyle(
//                   fontFamily: "BankGothic",
//                   color: Colors.white,
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             );
//           } else {
//             return ListView.builder(
//               itemCount: messageProvider.chatList.length,
//               itemBuilder: (context, index) {
//                 MessageModel message = messageProvider.chatList[index];
//                 return ListTile(
//                   title: Text(message.message ?? ''),
//                   subtitle: Text(message.datetime ?? ''),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

// Future<void> onChallenge(
//     {required String challengeId, required String exerciseId}) async {
//   var pro = Provider.of<MessageProvider>(context, listen: false);

//   var data = {
//     'user_id': pref!.getString(userIdKey) ?? '',
//     'challenger_id': challengeId,
//     'exercise_id': exerciseId,
//   };

//   pro.addChat(context: context, data: data).then((value) {});
// }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/usersModel.dart';
import 'package:touchmaster/providers/challengesProvider.dart';
import 'package:touchmaster/providers/messageProviders.dart';
import 'package:touchmaster/providers/userProvider.dart';
import 'package:touchmaster/screens/account/profile1.dart';
import 'package:touchmaster/utils/constant.dart';
import 'package:touchmaster/utils/customLoader.dart';

import '/app_image.dart';
import '/screens/account/profile.dart';
import '/utils/size_extension.dart';

class OpenMessageScreen extends StatefulWidget {
  String? receiverId;
  String senderId;
  //final UsersModel users;
  OpenMessageScreen({super.key, this.receiverId, required this.senderId});

  @override
  State<OpenMessageScreen> createState() =>
      _OpenMessageScreenState(receiverId1: receiverId, senderId: senderId);
}

class _OpenMessageScreenState extends State<OpenMessageScreen> {
  TextEditingController textcontroller = TextEditingController();
  SharedPreferences? pref;
  String? receiverId1;
  String? senderId;
  _OpenMessageScreenState({required this.receiverId1, required this.senderId});
  // List<String> messges = [
  //   "hi",
  //   "hello",
  //   "A dummy note from the person.",
  //   "i am fine. and you?",
  //   "not well"
  // ];

  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    //  log('receiverId========>>>$')
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
              'munish',
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
        body: Consumer<MessageProvider>(
          builder: (context, userprovider, _) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 80.h,
                    left: 16.w,
                    right: 16.w,
                  ),
                  child: ListView.builder(
                    itemCount: userprovider.chatList.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    //    reverse: true,

                    itemBuilder: (context, index) {
                      var item = userprovider.chatList[index];
                      log('userprofile response======>>>>>>$item');
                      if (index.isEven || index.isOdd) {
                        return ChatBubble(
                          elevation: 0,
                          clipper: ChatBubbleClipper5(
                            type: BubbleType.receiverBubble,
                          ),
                          backGroundColor: const Color(0xff323232),
                          margin: const EdgeInsets.only(top: 20),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.65,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  child: Text(
                                    item.message ?? '',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(item.datetime ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      // color: const Color(0xff7C7C7C))
                                    ))
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
                          controller: textcontroller,
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
                                  borderSide: const BorderSide(
                                      color: Color(0xff323232))),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xff323232))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xff323232))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xff323232))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xff323232))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xff323232))),
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

                        Consumer<UsersProvider>(
                          builder: (context, value, child) {
                            return InkWell(
                              onTap: () {
                                log('senderID==${senderId}');
                                log('receiverID==${receiverId1}');
                                log('response=====>>>>>$receiverId1');
                                //var item = value.userProfile;
                                onChatAdd(
                                    receiverId: widget.receiverId.toString(),
                                    message: textcontroller.text,
                                    senderId: widget.senderId);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  color: Color(0xff24D993),
                                  shape: BoxShape.circle,
                                ),
                                //child: Text('Send'),
                                child: const AppImage("assets/ic_send.svg"),
                              ),
                            );
                          },
                        )
                        // var response = onChatAdd(
                        //     receiverId: , message: 'hey');
                        // log('inbox response====>>>$response');
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }

  Future<void> onChatAdd(
      {required String receiverId,
      required String message,
      required String senderId}) async {
    var pro = Provider.of<MessageProvider>(context, listen: false);
    // var senderId = pref!.getString(userIdKey) ?? '';

    var data = {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': textcontroller.text,
    };

    log('senderID response Api====>>>$senderId');
    // log('onchatAdd response======================>>>>>>>>>>>>>>>>>>>>>>>>$data');
    pro.addChat(context: context, data: data).then((value) {});
    setState(() {
      textcontroller.clear();
    });
  }
}
