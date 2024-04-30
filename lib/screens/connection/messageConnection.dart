import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/usersModel.dart';
import 'package:touchmaster/screens/account/profile1.dart';
import 'package:touchmaster/screens/message/openmessage.dart';
import 'package:touchmaster/utils/commonMethod.dart';

import '../../app_image.dart';
import '../../common/cacheImage.dart';
import '../../providers/userProvider.dart';
import '../../utils/color.dart';
import '../../utils/constant.dart';
import '../account/profile.dart';
import '/utils/size_extension.dart';
import 'usersProfile.dart';

class MessageConnectionsScreen extends StatefulWidget {
  const MessageConnectionsScreen({Key? key}) : super(key: key);

  @override
  State<MessageConnectionsScreen> createState() =>
      _MessageConnectionsScreenState();
}

class _MessageConnectionsScreenState extends State<MessageConnectionsScreen> {
  TextEditingController searchController = TextEditingController();
  List<UsersModel> filteredUsers = [];

  SharedPreferences? pref;

  @override
  void initState() {
    super.initState();
    _initFun();
  }

  _initFun() async {
    pref = await SharedPreferences.getInstance();
    var data = {'user_id': pref!.getString(userIdKey).toString() ?? ''};
    log('UserFound---------->>>> $data');
    await Provider.of<UsersProvider>(context, listen: false)
        .getAllUsers(context: context, data: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Connections",
          style: TextStyle(
            letterSpacing: 4,
            fontFamily: "BankGothic",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 20),
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
                // InkWell(
                //   onTap: () {
                //     // Add functionality to trigger search here
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Color(0xff24D993),
                //     ),
                //     child: Icon(Icons.search, color: Colors.black, size: 25),
                //   ),
                // ),
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
                  return Column(
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OpenMessageScreen(
                                            senderId: item.userId,
                                          )),
                                );
                              },
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
                                  'message',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      const Divider(
                        height: 1,
                        thickness: 0.3,
                      ),
                    ],
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
