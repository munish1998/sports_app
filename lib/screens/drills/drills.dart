// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '/screens/notifications/notifications.dart';
// import '/screens/video/levelScreen.dart';
// import '/utils/size_extension.dart';

// import '../../cacheImage.dart';
// import '../../common/app_colors.dart';
// import '../../common/commonBottomBar.dart';

// class DrillsScreen extends StatefulWidget {
//   const DrillsScreen({super.key});

//   @override
//   State<DrillsScreen> createState() => _DrillsScreenState();
// }

// class _DrillsScreenState extends State<DrillsScreen> {
//   PageController pageController = PageController();
//   int selectedindex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: AppImage(
//           "assets/logo.png",
//           height: 38.h,
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const NotificationScreen(),
//                 ),
//               );
//             },
//             icon: badges.Badge(
//               badgeStyle: badges.BadgeStyle(
//                 badgeColor: primaryColor,
//               ),
//               badgeContent: Text(
//                 '0',
//                 style: GoogleFonts.lato(
//                   color: Colors.black,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               child: const AppImage(
//                 "assets/notification.svg",
//               ),
//             ),
//           )
//         ],
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: InkWell(
//             onTap: () {
//               //      widget.parentScaffoldKey!.currentState!.openDrawer();
//             },
//             child: Icon(
//               Icons.menu,
//               color: Colors.white,
//               size: 30.sp,
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: CommonBottomBar(),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: 16,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 10.h,
//             ),
//             TextFormField(
//               style: GoogleFonts.mulish(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w400,
//                 color: const Color(0xffFFFFFF).withOpacity(0.5),
//               ),
//               decoration: InputDecoration(
//                   prefixIcon: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: AppImage("assets/search.svg"),
//                   ),
//                   hintText: "Search",
//                   hintStyle: GoogleFonts.mulish(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xffFFFFFF).withOpacity(0.5),
//                   ),
//                   isDense: true,
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                       borderRadius: BorderRadius.circular(10)),
//                   filled: true,
//                   fillColor: const Color(0xffC4C4C4).withOpacity(0.2)),
//             ),
//             SizedBox(
//               height: 20.h,
//             ),
//             Center(
//               child: Text(
//                 "Drills",
//                 style: TextStyle(
//                     letterSpacing: 2,
//                     fontFamily: "BankGothic",
//                     color: Colors.white,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w400),
//               ),
//             ),
//             SizedBox(
//               height: 15.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 InkWell(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   onTap: () {
//                     pageController.jumpToPage(0);
//                   },
//                   child: Column(
//                     children: [
//                       Text(
//                         "Endurance",
//                         style: TextStyle(
//                             letterSpacing: 2,
//                             fontFamily: "BankGothic",
//                             color: selectedindex == 0
//                                 ? Color(0xff24D993)
//                                 : Colors.white,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       SizedBox(
//                         height: 15.h,
//                       ),
//                       Container(
//                         height: 2.h,
//                         width: 80.w,
//                         decoration: BoxDecoration(
//                             color: selectedindex == 0
//                                 ? Color(0xff24D993)
//                                 : Colors.transparent),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                   child: VerticalDivider(
//                     thickness: 1,
//                     color: Color(0xff323232),
//                   ),
//                 ),
//                 InkWell(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   onTap: () {
//                     pageController.jumpToPage(1);
//                   },
//                   child: Column(
//                     children: [
//                       Text(
//                         "Speed & Agility",
//                         style: TextStyle(
//                             letterSpacing: 2,
//                             fontFamily: "BankGothic",
//                             color: selectedindex == 1
//                                 ? Color(0xff24D993)
//                                 : Colors.white,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       SizedBox(
//                         height: 15.h,
//                       ),
//                       Container(
//                         height: 2.h,
//                         width: 110.w,
//                         decoration: BoxDecoration(
//                             color: selectedindex == 1
//                                 ? Color(0xff24D993)
//                                 : Colors.transparent),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                   child: VerticalDivider(
//                     thickness: 1,
//                     color: Color(0xff323232),
//                   ),
//                 ),
//                 InkWell(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   onTap: () {
//                     pageController.jumpToPage(2);
//                   },
//                   child: Column(
//                     children: [
//                       Text(
//                         "Technical",
//                         style: TextStyle(
//                             letterSpacing: 2,
//                             fontFamily: "BankGothic",
//                             color: selectedindex == 2
//                                 ? Color(0xff24D993)
//                                 : Colors.white,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       SizedBox(
//                         height: 15.h,
//                       ),
//                       Container(
//                         height: 2.h,
//                         width: 75.w,
//                         decoration: BoxDecoration(
//                             color: selectedindex != 2
//                                 ? Colors.transparent
//                                 : Color(0xff24D993)),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 20.h,
//             ),
//             Flexible(
//               child: PageView.builder(
//                   controller: pageController,
//                   onPageChanged: (value) {
//                     setState(() {
//                       selectedindex = value;
//                     });
//                   },
//                   itemCount: 3,
//                   physics: AlwaysScrollableScrollPhysics(),

//                   //      scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return ListView.separated(
//                       separatorBuilder: (context, index) {
//                         return SizedBox(
//                           height: 10.h,
//                         );
//                       },
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => VideoDetailScreen(),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             width: 200,
//                             height: 112.h,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xff323232),
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: AppImage(
//                                     "assets/tbackground.png",
//                                     height: 91.h,
//                                     width: 91.w,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Container(
//                                       margin: EdgeInsets.only(left: 120.w),
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 4.w,
//                                         vertical: 2.h,
//                                       ),
//                                       decoration: const BoxDecoration(
//                                           color: Colors.transparent,
//                                           borderRadius: BorderRadius.only(
//                                               bottomLeft: Radius.circular(5.5),
//                                               bottomRight:
//                                                   Radius.circular(5.5))),
//                                       // child: Text(
//                                       //   "Intermediate",
//                                       //   style: GoogleFonts.poppins(
//                                       //       fontSize: 9.sp,
//                                       //       fontWeight: FontWeight.w400,
//                                       //       color: const Color(0xff323232)),
//                                       // ),
//                                     ),
//                                     SizedBox(
//                                       height: 15.h,
//                                     ),
//                                     Text(
//                                       "Make yourself unmark...",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.white,
//                                         fontSize: 15.sp,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 5.h,
//                                     ),
//                                     Text(
//                                       "30 Mins",
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.white.withOpacity(0.5),
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10.h,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Container(
//                                           height: 16.h,
//                                           width: 165.w,
//                                           //      width: double.infinity,
//                                           decoration: BoxDecoration(
//                                               color: const Color(0xff777777),
//                                               borderRadius:
//                                                   BorderRadius.circular(3)),
//                                           child: Container(
//                                             width: 80.w,
//                                             margin:
//                                                 EdgeInsets.only(right: 80.w),
//                                             decoration: const BoxDecoration(
//                                                 color: Color(0xff24D993)),
//                                             child: Center(
//                                               child: Text(
//                                                 "80%",
//                                                 style: GoogleFonts.poppins(
//                                                   color: Colors.black,
//                                                   fontSize: 7.sp,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10.w,
//                                         ),
//                                         Container(
//                                           child: Icon(
//                                             Icons.play_arrow,
//                                             color: Colors.black,
//                                             size: 18.sp,
//                                           ),
//                                           decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Color(0xff24D993)),
//                                         ),
//                                         SizedBox(
//                                           width: 10.w,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       itemCount: 10,
//                       shrinkWrap: true,
//                       primary: false,
//                     );
//                   }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
