import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/inboxMessageModel.dart';
import 'package:touchmaster/model/mesageModel.dart';
import 'package:touchmaster/providers/messageProviders.dart';
import 'package:touchmaster/screens/connection/messageConnection.dart';

import 'package:touchmaster/utils/constant.dart';

import '../../utils/color.dart';
import '/common/cacheImage.dart';
import '/screens/message/openmessage.dart';
import '/utils/commonMethod.dart';
import '/utils/size_extension.dart';

class InboxMessageScreen extends StatefulWidget {
  InboxMessageScreen({
    Key? key,
  });

  @override
  _InboxMessageScreenState createState() => _InboxMessageScreenState();
}

class _InboxMessageScreenState extends State<InboxMessageScreen> {
  TextEditingController _searchcontroller = TextEditingController();
  List<MessageInboxModel> filteredMessages = [];
  late SharedPreferences pref;
  late String rceiverId;
  bool _isSeraching = false;
  //String userID = pref!.getString(userIdKey) ?? '';
  @override
  void initState() {
    super.initState();
    initFun();
  }

  initFun() async {
    var pro = Provider.of<MessageProvider>(context, listen: false);

    pref = await SharedPreferences.getInstance();
    rceiverId = pref!.getString(userIdKey) ?? '';
    var data = {'user_id': rceiverId};
    log('userId response===>>>$rceiverId');
    log('response of get chat====---===----$data');
    pro.getChatInbox(context: context, data: data);
  }

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
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: _isSeraching
            ? TextField(
                controller: _searchcontroller,
                onChanged: (value) {
                  filterMessages(value);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'name, email....',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                autofocus: true,
              )
            : Text(
                "Inbox",
                style: TextStyle(
                  letterSpacing: 4,
                  fontFamily: "BankGothic",
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSeraching = !_isSeraching;
              });
            },
            icon: Icon(
                _isSeraching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search,
                color: Colors.white),
          ),
        ],
      ),
      body: Consumer<MessageProvider>(
        builder: (context, data, child) {
          return (data.inboxList.isEmpty)
              ? ConnectionsScreen1()
              : Container(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 25,
                        );
                      },
                      itemCount: data.inboxList.length,
                      itemBuilder: (context, index) {
                        var item = data.inboxList[index];
                        return InkWell(
                          onTap: () {
                            //  log('currentuserId===>>>$')
                            navPush(
                              context: context,
                              action: OpenMessageScreen(
                                receiverId: rceiverId == item.userId
                                    ? item.userId
                                    : rceiverId,
                                senderId: item.userId!,
                                currentuserId: rceiverId,
                                senderName: item.userName.toString(),
                                receiverName: '',
                              ),
                            );
                            // //  OpenMessageScreen(senderId: );
                            // log('senderID===>>>${item.userId}');
                            // log('response of receiverId===>>>$item');
                            // log('response of chstinbox list ====>>>$item');
                            // // log('userId===>>>$userId');
                            // navPush(
                            //     context: context,
                            //     action: OpenMessageScreen(
                            //       senderId: item.userId!,
                            //       receiverId: rceiverId,
                            //     ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              cacheImages(
                                image: item.profilePicture!,
                                radius: 100,
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // 'god morning',
                                          item.userName ?? '',
                                          style: GoogleFonts.inter(
                                            color: white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: Color(0xff24D993),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            item.unreadCount!,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      item.lastMessage ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xff8F9BB3),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }

  void filterMessages(String query) {
    if (query.isNotEmpty) {
      List<MessageInboxModel> tempList = [];
      // Assuming inboxList contains MessageModel objects
      Provider.of<MessageProvider>(context, listen: false)
          .inboxList
          .forEach((message) {
        if (message.userName!.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(message);
        }
      });
      setState(() {
        filteredMessages = tempList;
      });
    } else {
      setState(() {
        filteredMessages = [];
      });
    }
  }
}
