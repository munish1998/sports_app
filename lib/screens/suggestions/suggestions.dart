// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:touchmaster/model/usersModel.dart';
// import 'package:touchmaster/utils/commonMethod.dart';

// import '../../app_image.dart';
// import '../../common/cacheImage.dart';
// import '../../providers/userProvider.dart';
// import '../../utils/color.dart';
// import '../../utils/constant.dart';
// import '../account/profile.dart';
// import '/utils/size_extension.dart';
// import '../connection/usersProfile.dart';

// class SuggestionScreen extends StatefulWidget {
//   const SuggestionScreen({Key? key}) : super(key: key);

//   @override
//   State<SuggestionScreen> createState() => _SuggestionScreenState();
// }

// class _SuggestionScreenState extends State<SuggestionScreen> {
//   TextEditingController searchController = TextEditingController();
//   List<UsersModel> filteredUsers = [];

//   SharedPreferences? pref;

//   @override
//   void initState() {
//     super.initState();
//     _initFun();
//   }

//   _initFun() async {
//     pref = await SharedPreferences.getInstance();
//     var data = {'user_id': pref!.getString(userIdKey).toString() ?? ''};
//     log('UserFound---------->>>> $data');
//     await Provider.of<UsersProvider>(context, listen: false)
//         .getAllUsers(context: context, data: data);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: Text(
//           "Suggestions",
//           style: TextStyle(
//             letterSpacing: 4,
//             fontFamily: "BankGothic",
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios_new),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: searchController,
//                     onChanged: (value) {
//                       filterUsers(
//                         value,
//                         Provider.of<UsersProvider>(context, listen: false)
//                             .usersSuggestList,
//                       );
//                     },
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.white,
//                     ),
//                     decoration: InputDecoration(
//                       prefixIcon: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: AppImage("assets/search.svg"),
//                       ),
//                       hintText: "Search",
//                       hintStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white.withOpacity(0.5),
//                       ),
//                       isDense: true,
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       filled: true,
//                       fillColor: Color(0xffC4C4C4).withOpacity(0.2),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 // InkWell(
//                 //   onTap: () {
//                 //     // Add functionality to trigger search here
//                 //   },
//                 //   child: Container(
//                 //     padding: EdgeInsets.all(12),
//                 //     decoration: BoxDecoration(
//                 //       shape: BoxShape.circle,
//                 //       color: Color(0xff24D993),
//                 //     ),
//                 //     child: Icon(Icons.search, color: Colors.black, size: 25),
//                 //   ),
//                 // ),
//               ],
//             ),
//             SizedBox(height: 40),
//             listOfUsers(filteredUsers.isEmpty
//                 ? Provider.of<UsersProvider>(context, listen: false)
//                     .usersSuggestList
//                 : filteredUsers),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget listOfUsers(List<UsersModel> users) {
//     return Expanded(
//       child: users.isEmpty
//           ? Consumer<UsersProvider>(builder: (context, data, child) {
//               return ListView.separated(
//                 physics: BouncingScrollPhysics(),
//                 itemCount: data.usersSuggestList.length,
//                 itemBuilder: (context, index) {
//                   var item = data.usersSuggestList[index];
//                   return InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ProfileScreen()),
//                       );
//                     },
//                     child: Column(
//                       children: [
//                         InkWell(
//                           onTap: () async {
//                             navPush(
//                               context: context,
//                               action: UsersProfileScreen(
//                                 profileId: item.userId,
//                                 follow: item.follow,
//                               ),
//                             );
//                           },
//                           child: Row(
//                             children: [
//                               cacheImages(
//                                 image: item.profilePicture,
//                                 radius: 100,
//                                 height: 50,
//                                 width: 50,
//                               ),
//                               SizedBox(width: 30),
//                               Text(
//                                 item.name,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               Spacer(),
//                               InkWell(
//                                 onTap: () async {
//                                   // Add follow/unfollow functionality here
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: item.follow == 'no'
//                                         ? primary
//                                         : Colors.white,
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: Text(
//                                     item.follow == 'no' ? "Follow" : "Remove",
//                                     style: TextStyle(
//                                       color: item.follow == 'no'
//                                           ? Colors.white
//                                           : primary,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         const Divider(
//                           height: 1,
//                           thickness: 0.3,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 separatorBuilder: (context, index) {
//                   return SizedBox(height: 15);
//                 },
//               );
//             })
//           : ListView.separated(
//               physics: BouncingScrollPhysics(),
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 var item = users[index];
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProfileScreen()),
//                     );
//                   },
//                   child: Column(
//                     children: [
//                       InkWell(
//                         onTap: () async {
//                           navPush(
//                             context: context,
//                             action: UsersProfileScreen(
//                               profileId: item.userId,
//                               follow: item.follow,
//                             ),
//                           );
//                         },
//                         child: Row(
//                           children: [
//                             cacheImages(
//                               image: item.profilePicture,
//                               radius: 100,
//                               height: 50,
//                               width: 50,
//                             ),
//                             SizedBox(width: 30),
//                             Text(
//                               item.name,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Spacer(),
//                             InkWell(
//                               onTap: () async {
//                                 // Add follow/unfollow functionality here
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: item.follow == 'no'
//                                       ? primary
//                                       : Colors.white,
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Text(
//                                   item.follow == 'no' ? "Follow" : "Remove",
//                                   style: TextStyle(
//                                     color: item.follow == 'no'
//                                         ? Colors.white
//                                         : primary,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       const Divider(
//                         height: 1,
//                         thickness: 0.3,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               separatorBuilder: (context, index) {
//                 return SizedBox(height: 15);
//               },
//             ),
//     );
//   }

//   void filterUsers(String query, List<UsersModel> allUsers) {
//     if (query.isNotEmpty) {
//       List<UsersModel> tempList = [];
//       allUsers.forEach((user) {
//         if (user.name.toLowerCase().contains(query.toLowerCase())) {
//           tempList.add(user);
//         }
//       });
//       setState(() {
//         filteredUsers = tempList;
//       });
//     } else {
//       setState(() {
//         filteredUsers = [];
//       });
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/screens/account/profile1.dart';

import '../../providers/userProvider.dart';
import '../../utils/constant.dart';
import '../connection/usersProfile.dart';
import '/app_image.dart';
import '/common/cacheImage.dart';
import '/screens/account/profile.dart';
import '/utils/color.dart';
import '/utils/commonMethod.dart';
import '/utils/size_extension.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  SharedPreferences? pref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    pref = await SharedPreferences.getInstance();
    getUsers();
  }

  getUsers() async {
    var data = {'user_id': pref!.getString(userIdKey).toString() ?? ''};
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
          "Suggestions",
          style: TextStyle(
              letterSpacing: 4,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
          onPressed: () {
            navPop(context: context);
            getUsers();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffFFFFFF),
                      ),
                      decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: AppImage("assets/search.svg"),
                          ),
                          hintText: "Search",
                          hintStyle: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF).withOpacity(0.5),
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: const Color(0xffC4C4C4).withOpacity(0.2)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff24D993),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 25,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              listOfUsers,
            ],
          ),
        ),
      ),
    );
  }

  Widget get listOfUsers =>
      Consumer<UsersProvider>(builder: (context, data, child) {
        return Container(
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.usersSuggestList.length,
            itemBuilder: (context, index) {
              var item = data.usersSuggestList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
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
                            ));
                      },
                      child: Row(
                        children: [
                          cacheImages(
                              image: item.profilePicture,
                              radius: 100,
                              height: 50,
                              width: 50),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              if (item.follow == 'no') {
                                var dataSuggest = {
                                  'user_id':
                                      pref!.getString(userIdKey).toString() ??
                                          '',
                                  'follow_user_id': item.userId,
                                  'status': 'follow',
                                };

                                data.followUnFollow(
                                    context: context, data: dataSuggest);
                                setState(() {
                                  item.follow = 'yes';
                                  data.removeUser(item, 1);
                                  data.addUser(item, 0);
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                  color:
                                      (item.follow == 'no') ? primary : white,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                (item.follow == 'no') ? "Follow" : "Following",
                                style: GoogleFonts.mulish(
                                  color:
                                      (item.follow == 'no') ? white : primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 0.3,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 15.h,
              );
            },
          ),
        );
      });
}
