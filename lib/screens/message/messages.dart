// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:touchmaster/providers/messageProviders.dart';

// import 'package:touchmaster/utils/constant.dart';

// import '../../utils/color.dart';
// import '/common/cacheImage.dart';
// import '/screens/message/openmessage.dart';
// import '/utils/commonMethod.dart';
// import '/utils/size_extension.dart';

// class MessageScreen extends StatefulWidget {
//   MessageScreen({
//     Key? key,
//   });

//   @override
//   _MessageScreenState createState() => _MessageScreenState();
// }

// class _MessageScreenState extends State<MessageScreen> {
//   SharedPreferences? pref;

//   @override
//   void initState() {
//     super.initState();
//     initFun();
//   }

//   initFun() async {
//     var pro = Provider.of<MessageProvider>(context, listen: false);

//     pref = await SharedPreferences.getInstance();
//     var data = {
//       'user_id': pref!.getString(userIdKey) ?? '',
//     };
//     log('response of get chat====---===----$data');
//     pro.getChat(context: context, data: data);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         title: Text(
//           "Inbox",
//           style: TextStyle(
//             letterSpacing: 4,
//             fontFamily: "BankGothic",
//             color: Colors.white,
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.menu,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//       body: Consumer<MessageProvider>(
//         builder: (context, data, child) {
//           return (data.chatList.isEmpty)
//               ? Center(
//                   child: Text(
//                     'You have no any connection yet!',
//                     style: TextStyle(color: Colors.white54),
//                   ),
//                 )
//               : Container(
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: ListView.separated(
//                       separatorBuilder: (context, index) {
//                         return SizedBox(
//                           height: 25,
//                         );
//                       },
//                       itemCount: data.chatList.length,
//                       itemBuilder: (context, index) {
//                         var item = data.chatList[index];
//                         return InkWell(
//                           onTap: () {
//                             // log('rceiverId======>>>>>>$item');
//                             // log('receiverId response=====>>>>>${item.receiverId}');
//                             // log('senderId response======>>>>>>${item.senderId}');
//                             navPush(
//                               context: context,
//                               action: OpenMessageScreen(
//                                 receiverId: item.receiverId.toString() ==
//                                         pref!.getString(userIdKey).toString()
//                                     ? item.senderId.toString()
//                                     : item.receiverId.toString(),
//                                 senderId: item.senderId.toString(),
//                               ),
//                             );
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               cacheImages(
//                                 image: '',
//                                 radius: 100,
//                                 height: 50,
//                                 width: 50,
//                               ),
//                               SizedBox(
//                                 width: 15,
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           item.senderId ?? '',
//                                           style: GoogleFonts.inter(
//                                             color: white,
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         Container(
//                                           padding: const EdgeInsets.all(6),
//                                           decoration: const BoxDecoration(
//                                             color: Color(0xff24D993),
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Text(
//                                             "2",
//                                             style: GoogleFonts.inter(
//                                               color: Colors.white,
//                                               fontSize: 12.sp,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       item.datetime ?? '',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: Color(0xff8F9BB3),
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//         },
//       ),
//     );
//   }
// }
