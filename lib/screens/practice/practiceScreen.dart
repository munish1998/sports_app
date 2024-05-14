// import 'dart:collection';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:touchmaster/model/practiceModel.dart';
// import 'package:touchmaster/utils/commonMethod.dart';

// import '../../utils/color.dart';
// import '../../utils/constant.dart';
// import '/app_image.dart';
// import '/common/cacheImage.dart';
// import '/providers/practiceProvider.dart';
// import '/utils/size_extension.dart';
// import 'practicePlayerScreen.dart';

// class PracticeScreen extends StatefulWidget {
//   // PracticeCateModel? practiceCateModel;
//   PracticeScreen({
//     super.key,
//   });

//   @override
//   State<PracticeScreen> createState() => _PracticeScreenState();
// }

// class _PracticeScreenState extends State<PracticeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
//   List<PracticeModel> practicelist = [];
//   PageController pageController = PageController();
//   int selectedIndex = 0;
//   SharedPreferences? pref;
//   // late String categoryID;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _initFun('0');
//   }

//   _initFun(String practiceId) async {
//     var pro = Provider.of<PracticeProvider>(context, listen: false);
//     pref = await SharedPreferences.getInstance();
//     pro.reset();
//     _getPractice(practiceId.toString());
//     // log('response of category id ====>>>>${pro.practiceModel!.categoryId}');
//   }

//   _initFun1() async {
//     var pro = Provider.of<PracticeProvider>(context, listen: false);
//     pref = await SharedPreferences.getInstance();
//     pro.reset();

//     for (var practice in pro.practiceList) {
//       // _getPractice(practice); // Pass the PracticeModel directly
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: 16.w,
//         ),
//         child: Consumer<PracticeProvider>(builder: (context, data, child) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 10.h,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       style: GoogleFonts.mulish(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: white,
//                       ),
//                       decoration: InputDecoration(
//                           prefixIcon: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: AppImage("assets/search.svg"),
//                           ),
//                           hintText: "Search",
//                           hintStyle: GoogleFonts.mulish(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: white.withOpacity(0.5),
//                           ),
//                           isDense: true,
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(10)),
//                           filled: true,
//                           fillColor: Color(0xffC4C4C4).withOpacity(0.2)),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10.h,
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Color(0xff24D993),
//                     ),
//                     child: Icon(
//                       Icons.search,
//                       color: Colors.black,
//                       size: 25.h,
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Center(
//                 child: Text(
//                   'Lear and Practice',
//                   style: TextStyle(
//                       letterSpacing: 2,
//                       fontFamily: "BankGothic",
//                       color: Colors.white,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w400),
//                 ),
//               ),
//               SizedBox(
//                 height: 15.h,
//               ),
//               categoryTop,
//               SizedBox(
//                 height: 20.h,
//               ),
//               Expanded(child: practiceWidget),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   Widget get categoryTop =>
//       Consumer<PracticeProvider>(builder: (context, data, child) {
//         return Container(
//           height: 45,
//           width: double.infinity,
//           child: ListView.separated(
//             itemCount: data.practiceCate.length,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               var item = data.practiceCate[index];
//               return InkWell(
//                 onTap: () {
//                   data.setIndex(index);
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.symmetric(vertical: 5),
//                   decoration: BoxDecoration(
//                     border: Border(
//                         bottom: (data.ceteIndex == index)
//                             ? BorderSide(
//                                 width: 2,
//                                 color: primary,
//                               )
//                             : BorderSide.none),
//                   ),
//                   child: Text(
//                     item.title,
//                     style: TextStyle(
//                       color: (data.ceteIndex == index) ? primary : white,
//                       fontSize: 15,
//                       letterSpacing: 2,
//                       fontFamily: "BankGothic",
//                     ),
//                   ),
//                 ),
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 height: 35,
//                 width: 2,
//                 decoration: BoxDecoration(color: red),
//               );
//             },
//           ),
//         );
//       });

//   Widget get practiceWidget =>
//       Consumer<PracticeProvider>(builder: (context, data, child) {
//         return Container(
//           child: ListView.separated(
//             itemCount: data.practiceList.length,
//             separatorBuilder: (context, index) {
//               return SizedBox(
//                 height: 10,
//               );
//             },
//             itemBuilder: (context, index) {
//               var item = data.practiceList[index];
//               return InkWell(
//                 onTap: () {
//                   navPush(
//                       context: context,
//                       action: PracticeContentScreen(
//                         practice: item,
//                       ));
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   height: 80,
//                   decoration: BoxDecoration(
//                       color: grey, borderRadius: BorderRadius.circular(10)),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: cacheImages(
//                             image: item.bgImage,
//                             radius: 10,
//                             height: 80,
//                             width: 100),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Text(
//                             item.title,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.poppins(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                             "${item.duration} ${item.durationType}",
//                             style: GoogleFonts.poppins(
//                               color: Colors.white.withOpacity(0.5),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             primary: false,
//           ),
//         );
//       });

//   Future<void> _getPractice(String practiceID) async {
//     var pro = Provider.of<PracticeProvider>(context, listen: false);
//     var data = {
//       'user_id': pref!.getString(userIdKey).toString() ?? '',
//       'category_id': practiceID.toString() // Use null-aware operator
//     };
//     // log('response of getpractice====>>>>>>>$data');
//     // log('response of category id ===>>>${widget.practiceCateModel!.id}');
//     log('response id id====>>>>$data}');
//     pro.getPractices(context: context, data: data);
//   }
// }

// // Future<void> _getPractice1(PracticeModel practice) async {
// //   var pro = Provider.of<PracticeProvider>(context, listen: false);
// //   var data = {
// //     'user_id': pref!.getString(userIdKey).toString() ?? '',
// //     'category_id': practice.categoryId,
// //   };
// //   log('response of getpractice====>>>>>>>$data');
// //   log('categoryID====>>>>${practice.categoryId}');
// //   pro.getPractices(context: context, data: data);
// // }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/practiceModel.dart';
import 'package:touchmaster/utils/commonMethod.dart';

import '../../utils/color.dart';
import '../../utils/constant.dart';
import '/app_image.dart';
import '/common/cacheImage.dart';
import '/providers/practiceProvider.dart';
import '/utils/size_extension.dart';
import 'practicePlayerScreen.dart';

class PracticeScreen extends StatefulWidget {
  // PracticeModel? practiceModel;
  PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  PracticeModel? practiceModel;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  _PracticeScreenState({this.practiceModel});

  PageController pageController = PageController();
  int selectedIndex = 0;
  SharedPreferences? pref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun("0");
  }

  _initFun(String? practiceId) async {
    var pro = Provider.of<PracticeProvider>(context, listen: false);
    pref = await SharedPreferences.getInstance();

    _getPractice(practiceId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: Consumer<PracticeProvider>(builder: (context, data, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: white,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: AppImage("assets/search.svg"),
                          ),
                          hintText: "Search",
                          hintStyle: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: white.withOpacity(0.5),
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Color(0xffC4C4C4).withOpacity(0.2)),
                    ),
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff24D993),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 25.h,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Text(
                  "Learn and Practice",
                  style: TextStyle(
                      letterSpacing: 2,
                      fontFamily: "BankGothic",
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              categoryTop,
              SizedBox(
                height: 20.h,
              ),
              Expanded(child: practiceWidget),
            ],
          );
        }),
      ),
    );
  }

  Widget get categoryTop =>
      Consumer<PracticeProvider>(builder: (context, data, child) {
        return Container(
          height: 45,
          width: double.infinity,
          child: ListView.separated(
            itemCount: data.practiceCate.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var item = data.practiceCate[index];
              return InkWell(
                onTap: () {
                  data.setIndex(index);
                  _initFun(index.toString());
                  setState(() {});
                  print("index :-> ${index.toString()}");
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: (data.ceteIndex == index)
                            ? BorderSide(
                                width: 2,
                                color: primary,
                              )
                            : BorderSide.none),
                  ),
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: (data.ceteIndex == index) ? primary : white,
                      fontSize: 15,
                      letterSpacing: 2,
                      fontFamily: "BankGothic",
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 35,
                width: 2,
                decoration: BoxDecoration(color: red),
              );
            },
          ),
        );
      });

  Widget get practiceWidget =>
      Consumer<PracticeProvider>(builder: (context, data, child) {
        return data.practiceList.isEmpty
            ? Center(
                child: Text(
                  "No Practice Found",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              )
            : ListView.separated(
                itemCount: data.practiceList.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  log("PracticesLength :-> ${data.practiceList.length}");
                  var item = data.practiceList[index];
                  return InkWell(
                    onTap: () {
                      navPush(
                          context: context,
                          action: PracticeContentScreen(
                            practice: item,
                          ));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                          color: grey, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: cacheImages(
                                image: item.bgImage,
                                radius: 10,
                                height: 80,
                                width: 100),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${item.duration} ${item.durationType}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                primary: false,
              );
      });

  Future<void> _getPractice(String practiceID) async {
    var pro = Provider.of<PracticeProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey).toString() ?? '',
      'category_id': practiceID.toString()
    };
    log("Data respnse:-> $data");
    pro.getPractices(context: context, data: data);
  }
}
