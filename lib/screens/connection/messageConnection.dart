import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/mesageModel.dart';
import 'package:touchmaster/model/usersModel.dart';
import 'package:touchmaster/providers/messageProviders.dart';
import 'package:touchmaster/screens/account/profile1.dart';
import 'package:touchmaster/screens/connection/connections.dart';
import 'package:touchmaster/screens/message/openmessage.dart';
import 'package:touchmaster/screens/plans/home.dart';
import 'package:touchmaster/utils/commonMethod.dart';

import '../../app_image.dart';
import '../../common/cacheImage.dart';
import '../../providers/userProvider.dart';
import '../../utils/color.dart';
import '../../utils/constant.dart';
import '../account/profile.dart';
import '/utils/size_extension.dart';
import 'usersProfile.dart';

class ConnectionsScreen1 extends StatefulWidget {
  String? receiverId;
  String? receiverName;
  MessageModel? messageModel;
  ConnectionsScreen1(
      {super.key, this.receiverId, this.receiverName, this.messageModel});

  @override
  State<ConnectionsScreen1> createState() => _ConnectionsScreen1State();
}

class _ConnectionsScreen1State extends State<ConnectionsScreen1> {
  TextEditingController searchController = TextEditingController();
  List<UsersModel> filteredUsers = [];

  SharedPreferences? pref;
  late String currentuserID = pref!.getString(userIdKey).toString();
  @override
  void initState() {
    super.initState();
    // initFun();
    _initFun();
  }

  // initFun() async {
  //   var pro = Provider.of<MessageProvider>(context, listen: false);

  //   pref = await SharedPreferences.getInstance();
  //   String rceiverId = pref!.getString(userIdKey) ?? '';
  //   var data = {'user_id': rceiverId};
  //   log('userId response===>>>$rceiverId');
  //   log('response of get chat====---===----$data');
  //   pro.getChatInbox(context: context, data: data);
  // }

  _initFun() async {
    pref = await SharedPreferences.getInstance();
    var currentuserID = pref!.getString(userIdKey) ?? '';
    var data = {'user_id': currentuserID};
    log('UserFound---------->>>> $data');
    log('response of currentuserID==>>>$currentuserID');
    await Provider.of<UsersProvider>(context, listen: false)
        .getAllUsers(context: context, data: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      filterUsers(
                        value,
                        Provider.of<UsersProvider>(context, listen: false)
                            .usersFollowList,
                      );
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(8),
                        child: AppImage("assets/search.svg"),
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Color(0xffC4C4C4).withOpacity(0.2),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 40),
            listOfUsers(filteredUsers.isEmpty
                ? Provider.of<UsersProvider>(context, listen: false)
                    .usersFollowList
                : filteredUsers),
          ],
        ),
      ),
    );
  }

  Widget listOfUsers(List<UsersModel> users) {
    return Expanded(
      child: users.isEmpty
          ? Consumer<UsersProvider>(builder: (context, data, child) {
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: data.usersFollowList.length,
                itemBuilder: (context, index) {
                  var item = data.usersFollowList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      );
                    },
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            navPush(
                              context: context,
                              action: UsersProfileScreen(
                                profileId: item.userId,
                                follow: item.follow,
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              cacheImages(
                                image: item.profilePicture,
                                radius: 100,
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(width: 30),
                              Text(
                                item.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  if (item.follow == 'yes') {
                                    var dataSuggest = {
                                      'user_id': pref!
                                              .getString(userIdKey)
                                              .toString() ??
                                          '',
                                      'follow_user_id': item.userId,
                                      'status': 'unfollow',
                                    };

                                    Provider.of<UsersProvider>(context,
                                            listen: false)
                                        .followUnFollow(
                                            context: context,
                                            data: dataSuggest);
                                    setState(() {
                                      item.follow = 'no';
                                      Provider.of<UsersProvider>(context,
                                              listen: false)
                                          .removeUser(item, 0);
                                      Provider.of<UsersProvider>(context,
                                              listen: false)
                                          .addUser(item, 1);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: item.follow == 'no'
                                        ? primary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.follow == 'no' ? "Follow" : "Remove",
                                    style: TextStyle(
                                      color: item.follow == 'no'
                                          ? Colors.white
                                          : primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: 10), // Add some space between buttons
                              // InkWell(
                              //   onTap: () {
                              //     // Navigate to chat screen
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => OpenMessageScreen(
                              //           receiverId: item.userId,
                              //           senderId:
                              //               pref!.getString(userIdKey) ?? '',
                              //           currentuserId:
                              //               pref!.getString(userIdKey) ?? '',
                              //           senderName: item.name.toString(),
                              //           receiverName: '',
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: 12,
                              //       vertical: 4,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       color: primary,
                              //       borderRadius: BorderRadius.circular(6),
                              //     ),
                              //     child: Text(
                              //       "Chat",
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 12,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        const Divider(
                          height: 1,
                          thickness: 0.3,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
              );
            })
          : ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var item = users[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          navPush(
                            context: context,
                            action: UsersProfileScreen(
                              profileId: item.userId,
                              follow: item.follow,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            cacheImages(
                              image: item.profilePicture,
                              radius: 100,
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(width: 30),
                            Text(
                              item.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () async {
                                if (item.follow == 'yes') {
                                  var dataSuggest = {
                                    'user_id':
                                        pref!.getString(userIdKey).toString() ??
                                            '',
                                    'follow_user_id': item.userId,
                                    'status': 'unfollow',
                                  };

                                  Provider.of<UsersProvider>(context,
                                          listen: false)
                                      .followUnFollow(
                                          context: context, data: dataSuggest);
                                  setState(() {
                                    item.follow = 'no';
                                    Provider.of<UsersProvider>(context,
                                            listen: false)
                                        .removeUser(item, 0);
                                    Provider.of<UsersProvider>(context,
                                            listen: false)
                                        .addUser(item, 1);
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: item.follow == 'no'
                                      ? primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.follow == 'no' ? "Follow" : "Remove",
                                  style: TextStyle(
                                    color: item.follow == 'no'
                                        ? Colors.white
                                        : primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 10), // Add some space between buttons
                            InkWell(
                              onTap: () {
                                String senderId;
                                String receiverId;

                                if (item.userId == currentuserID) {
                                  senderId = currentuserID;
                                  receiverId = item.userId;
                                } else {
                                  senderId = item.userId;
                                  receiverId = currentuserID;
                                }
                                log('response of senderID===>>>$senderId');
                                log('response of receiverID===>>>$receiverId');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OpenMessageScreen(
                                      receiverId: receiverId,
                                      senderId: senderId,
                                    ),
                                  ),
                                );
                              },

                              // onTap: () {

                              //   //  log('response of receiverID===>>>>>${widget.messageModel!.receiverId.toString()}');
                              //   log('response of senderId===>>>>${item.userId}');
                              //   log('response if senderName===>>>${item.name}');
                              //   log('response of cureentuserID===>>>>${pref!.getString(userIdKey).toString()}');
                              //   // OpenMessageScreen(
                              //   //   receiverId: currentuserID == item.userId
                              //   //       ? item.userId
                              //   //       : currentuserID,
                              //   //   senderId: item.userId,
                              //   //   currentuserId: currentuserID,
                              //   //   senderName: item.name.toString(),
                              //   //   receiverName: '',
                              //   // );
                              //   //   OpenMessageScreen(
                              //   //   receiverId: rceiverId == item.userId
                              //   //       ? item.userId
                              //   //       : rceiverId,
                              //   //   senderId: item.userId!,
                              //   //   currentuserId: rceiverId,
                              //   //   senderName: item.userName.toString(),
                              //   //   receiverName: '',
                              //   // ),
                              //   OpenMessageScreen(
                              //       receiverId: item.userId == currentuserID
                              //           ? currentuserID
                              //           : item.userId,
                              //       senderId: item.userId);
                              // },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Chat",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      const Divider(
                        height: 1,
                        thickness: 0.3,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 15);
              },
            ),
    );
  }

  void filterUsers(String query, List<UsersModel> allUsers) {
    if (query.isNotEmpty) {
      List<UsersModel> tempList = [];
      allUsers.forEach((user) {
        if (user.name.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(user);
        }
      });
      setState(() {
        filteredUsers = tempList;
      });
    } else {
      setState(() {
        filteredUsers = [];
      });
    }
  }
}
