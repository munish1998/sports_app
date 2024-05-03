import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/common/cacheImage.dart';
import 'package:touchmaster/model/mesageModel.dart';
import 'package:touchmaster/providers/messageProviders.dart';
import 'package:touchmaster/providers/userProvider.dart';
import 'package:touchmaster/utils/color.dart';
import 'package:touchmaster/utils/constant.dart';
import '/app_image.dart';
import '/screens/account/profile.dart';
import '/utils/size_extension.dart';

class OpenMessageScreen extends StatefulWidget {
  MessageModel? messageModel;
  String? senderName;
  String? receiverName;
  List<MessageModel> _chatList = [];
  String? receiverId;
  String senderId;
  String currentuserId;
  //final UsersModel users;
  OpenMessageScreen(
      {super.key,
      required this.receiverId,
      required this.senderId,
      required this.currentuserId,
      required this.senderName,
      required this.receiverName,
      this.messageModel});

  @override
  State<OpenMessageScreen> createState() =>
      _OpenMessageScreenState(receiverId1: receiverId, senderId: senderId);
}

class _OpenMessageScreenState extends State<OpenMessageScreen> {
  TextEditingController textcontroller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late SharedPreferences? pref;
  String? receiverId1;
  String? senderId;
  _OpenMessageScreenState({required this.receiverId1, required this.senderId});
  String? timeformat(String? datetime) {}
  String? _extractTime(String? datetime) {
    if (datetime == null || datetime.isEmpty) return null;

    var parts = datetime.split(' ');

    if (parts.length == 2) {
      var timeParts = parts[1].split(':');

      if (timeParts.length == 2) {
        return '${timeParts[0]}:${timeParts[1]}';
      }
    }

    return null;
  }
  // List<String> messges = [
  //   "hi",
  //   "hello",
  //   "A dummy note from the person.",
  //   "i am fine. and you?",
  //   "not well"
  // ];

  // ignore: empty_constructor_bodies
  @override
  void initState() {
    super.initState();
    // Initialize SharedPreferences in initState
    SharedPreferences.getInstance().then((value) {
      setState(() {
        pref = value;
        // Call initFun only after pref is initialized
        initFun();
      });
    }).catchError((error) {
      print('Error initializing SharedPreferences: $error');
      // Handle error if SharedPreferences initialization fails
    });
  }

  initFun() async {
    var pro = Provider.of<MessageProvider>(context, listen: false);

    var userId = pref!.getString(userIdKey) ?? '';
    if (userId.isEmpty) {
      throw Exception('Sender ID is empty');
    }
    var data = {'user_id': userId, 'chat_user_id': widget.senderId};
    log('response of get chat====---===----$data');
    pro.getChatHistory(context: context, data: data);
  }

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
              widget.currentuserId == widget.senderId.toString()
                  ? widget.receiverName.toString()
                  : widget.senderName.toString(),
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
          builder: (context, messageprovider, _) {
            return Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      bottom: 80.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Builder(builder: (context) {
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messageprovider.chatList.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var message = messageprovider.chatList[index];
                          log('message response===>>>>$message');
                          log('message chat===>>>>$pref');
                          bool isSender = message.senderId == senderId;

                          // Inside the ListView.builder itemBuilder method
                          return Align(
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 10
                                    .h, // Reduce the top margin for a more compact layout
                                left: isSender ? 100.w : 0,
                                right: isSender ? 0 : 100.w,
                              ),
                              child: ChatBubble(
                                elevation: 1,
                                clipper: ChatBubbleClipper5(
                                  type: isSender
                                      ? BubbleType.sendBubble
                                      : BubbleType.receiverBubble,
                                ),
                                backGroundColor:
                                    isSender ? Colors.white : primary,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        // Display message and time on the same line
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 4),
                                          Expanded(
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              message.message ?? '',
                                              style: TextStyle(
                                                color: isSender
                                                    ? primary
                                                    : Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            _extractTime(message.datetime) ??
                                                '',
                                            style: TextStyle(
                                              color: isSender
                                                  ? primary
                                                  : Colors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    })),
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
                                log('currentuserId====>>>>${widget.currentuserId}');
                                log('senderID==${widget.senderId}');
                                log('receiverID==$receiverId1');
                                String senderId = widget.senderId;
                                String receiverId =
                                    (senderId == widget.currentuserId)
                                        ? widget.receiverId.toString()
                                        : widget.senderId.toString();
                                // log('userid===>>>>${pref!.getString(userIdKey).toString()}');
                                // log('response=====>>>>>$receiverId1');
                                //var item = value.userProfile;

                                // onChatAdd(
                                //     receiverId: widget.receiverId.toString() ==
                                //             widget.currentuserId
                                //         ? widget.receiverId.toString()
                                //         : widget.senderId,
                                //     message: textcontroller.text,
                                //     senderId: widget.currentuserId);
                                // onChatAdd(
                                //     receiverId: widget.receiverId.toString() ==
                                //             pref!
                                //                 .getString(userIdKey)
                                //                 .toString()
                                //         ? widget.senderId
                                //         : widget.receiverId.toString(),
                                //     message: textcontroller.text,
                                //     senderId:
                                //         pref!.getString(userIdKey).toString());
                                onChatAdd(
                                    receiverId: receiverId,
                                    message: textcontroller.text,
                                    senderId: senderId);
                                setState(() {
                                  messageprovider.chatList.add(MessageModel(
                                    senderId: widget.senderId,
                                    receiverId: receiverId,
                                    message: textcontroller.text,
                                    datetime: DateTime.now()
                                        .toString(), // Assuming the current timestamp for the new message
                                  ));
                                });
                              },

                              // onTap: () {
                              //   log('currentuserId====>>>>${widget.currentuserId}');
                              //   log('senderID==${widget.senderId}');
                              //   log('receiverID==$receiverId1');
                              //   String senderId = widget.currentuserId;
                              //   String receiverId =
                              //       (senderId == widget.senderId)
                              //           ? widget.senderId.toString()
                              //           : widget.receiverId.toString();

                              //   // Call the sendMessage function to add the message to the provider
                              //   sendMessage(receiverId, textcontroller.text,
                              //       senderId, messageprovider);

                              //   // Clear the text field
                              //   textcontroller.clear();
                              // },

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

  void sendMessage(String receiverId, String message, String senderId,
      MessageProvider messageProvider) {
    // Add the message to the chatList
    setState(() {
      messageProvider.chatList.add(MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        datetime: DateTime.now()
            .toString(), // Assuming the current timestamp for the new message
      ));
    });
  }

  Future<void> onChatAdd({
    required String receiverId,
    required String message,
    required String senderId,
  }) async {
    var pro = Provider.of<MessageProvider>(context, listen: false);
    while (pref == null) {
      await Future.delayed(
          Duration(milliseconds: 100)); // Adjust delay as needed
    }
    // Retrieve senderId from SharedPreferences
    var actualSenderId = pref!.getString(userIdKey) ?? '';
    if (actualSenderId.isEmpty) {
      throw Exception('Sender ID is empty');
    }

    var data = {
      'sender_id': actualSenderId, // Use the retrieved senderId
      'receiver_id': receiverId,
      'message': textcontroller.text,
    };

    log('senderID response Api====>>>$actualSenderId');
    pro.addChat(context: context, data: data).then((value) {
      // Add the new message to the chat list
      setState(() {
        // Assuming the new message is returned in the response
        // Update the chat list with the new message
        // You may need to adjust this based on how the response is structured
      });
    });

    // Clear the text input field after sending the message
    textcontroller.clear();
  }
}
