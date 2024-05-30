// // import 'package:flutter/material.dart';
// // import 'package:touchmaster/utils/color.dart';
// // import 'package:touchmaster/utils/commonMethod.dart';
// // import 'package:touchmaster/utils/size_extension.dart';

// // class PaymentScreen extends StatefulWidget {
// //   const PaymentScreen({Key? key}) : super(key: key);

// //   @override
// //   State<PaymentScreen> createState() => _PaymentScreenState();
// // }

// // class _PaymentScreenState extends State<PaymentScreen> {
// //   final TextEditingController _cardNumberController = TextEditingController();
// //   final TextEditingController _expiryDateController = TextEditingController();
// //   final TextEditingController _cvvController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       resizeToAvoidBottomInset: false,
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         backgroundColor: Colors.black,
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             onPressed: () {},
// //             icon: const Icon(
// //               Icons.menu,
// //               color: Colors.black,
// //             ),
// //           )
// //         ],
// //         title: const Text(
// //           "PAYMENT METHOD",
// //           style: TextStyle(
// //             letterSpacing: 2,
// //             fontFamily: "BankGothic",
// //             color: Colors.white,
// //             fontSize: 20,
// //             fontWeight: FontWeight.w400,
// //           ),
// //         ),
// //         leading: IconButton(
// //           onPressed: () {
// //             navPop(context: context);
// //           },
// //           icon: const Icon(
// //             Icons.arrow_back_ios_new,
// //             color: white,
// //           ),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Image.asset('assets/card.png'),
// //                 SizedBox(
// //                   height: 20,
// //                 ),
// //                 Text(
// //                   "CARD DETAILS",
// //                   style: TextStyle(
// //                     letterSpacing: 2,
// //                     fontFamily: "BankGothic",
// //                     color: Colors.white,
// //                     fontSize: 15,
// //                     fontWeight: FontWeight.w400,
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: 20,
// //                 ),
// //                 Card(
// //                   elevation: 1,
// //                   child: Container(
// //                     width: 320,
// //                     height: 304,
// //                     color: const Color.fromRGBO(196, 196, 196, 0.2),
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(15.0),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'Name on card',
// //                             style: TextStyle(color: Colors.white, fontSize: 10),
// //                           ),
// //                           TextField(
// //                             decoration: InputDecoration(
// //                               hintText: 'Enter card name',
// //                             ),
// //                           ),
// //                           Text(
// //                             'Card number',
// //                             style: TextStyle(color: Colors.white, fontSize: 10),
// //                           ),
// //                           TextField(
// //                             controller: _cardNumberController,
// //                             keyboardType: TextInputType.number,
// //                             decoration: InputDecoration(
// //                               hintText: 'Enter card number',
// //                             ),
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 // Limit card number to 12 digits
// //                                 if (value.length > 16) {
// //                                   value = value.substring(0, 12);
// //                                   _cardNumberController.value =
// //                                       TextEditingValue(
// //                                     text: value,
// //                                     selection: TextSelection.collapsed(
// //                                         offset: value.length),
// //                                   );
// //                                 }
// //                               });
// //                             },
// //                           ),
// //                           SizedBox(
// //                             height: 10,
// //                           ),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     'Expiry date',
// //                                     style: TextStyle(
// //                                         color: Colors.white, fontSize: 10),
// //                                   ),
// //                                   Container(
// //                                     width: 120,
// //                                     child: TextField(
// //                                       controller: _expiryDateController,
// //                                       keyboardType: TextInputType.datetime,
// //                                       decoration: InputDecoration(
// //                                         hintText: 'MM/YY',
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                               Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     'CVV',
// //                                     style: TextStyle(
// //                                         color: Colors.white, fontSize: 10),
// //                                   ),
// //                                   Container(
// //                                     width: 80,
// //                                     child: TextField(
// //                                       controller: _cvvController,
// //                                       keyboardType: TextInputType.number,
// //                                       decoration: InputDecoration(
// //                                         hintText: 'CVV',
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




// import 'dart:developer';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_chat_bubble/chat_bubble.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:touchmaster/common/cacheImage.dart';
// import 'package:touchmaster/model/mesageModel.dart';
// import 'package:touchmaster/providers/messageProviders.dart';
// import 'package:touchmaster/providers/userProvider.dart';
// import 'package:touchmaster/utils/color.dart';
// import 'package:touchmaster/utils/constant.dart';
// import 'package:touchmaster/utils/customLoader.dart';
// import '/app_image.dart';
// import '/screens/account/profile.dart';
// import '/utils/size_extension.dart';

// class OpenMessageScreen2 extends StatefulWidget {
//   MessageModel? messageModel;
//   String? senderName;
//   String? receiverName;
//   List<MessageModel> _chatList = [];
//   String? receiverId;
//   String senderId;
//   String? currentuserId;
//   OpenMessageScreen2({
//     super.key,
//     required this.receiverId,
//     required this.senderId,
//     this.currentuserId,
//     this.senderName,
//     this.receiverName,
//     this.messageModel,
//   });

//   @override
//   State<OpenMessageScreen2> createState() =>
//       _OpenMessageScreen2State(receiverId1: receiverId, senderId: senderId);
// }

// class _OpenMessageScreen2State extends State<OpenMessageScreen2> {
//   TextEditingController textcontroller = TextEditingController();
//   ScrollController _scrollController = ScrollController();
//   late SharedPreferences? pref;
//   String? receiverId1;
//   String? senderId;
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   _OpenMessageScreenState({required this.receiverId1, required this.senderId});

//   @override
//   void initState() {
//     super.initState();
//     FirebaseMessaging.onMessage.listen((message) {
//       print("Message :-> ${message.data}");
//     });
//     FirebaseMessaging.instance.getInitialMessage().then((value) {
//       print("initial Message :-> ${value?.data}");
//     });

//     SharedPreferences.getInstance().then((value) {
//       setState(() {
//         pref = value;
//         initFun();
//       });
//     }).catchError((error) {
//       print('Error initializing SharedPreferences: $error');
//     });
//   }

//   initFun() async {
//     var pro = Provider.of<MessageProvider>(context, listen: false);
//     var userId = pref!.getString(userIdKey) ?? '';
//     if (userId.isEmpty) {
//       throw Exception('Sender ID is empty');
//     }
//     var data = {'user_id': userId, 'chat_user_id': widget.senderId};
//     log('response of get chat====---===----$data');
//     pro.getChatHistory(context: context, data: data);
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           _selectedImage = File(pickedFile.path);
//         });
//         _onSendImage();
//       }
//     } catch (e) {
//       log('Error picking image: $e');
//     }
//   }

//   void _onSendImage() {
//     if (_selectedImage != null) {
//       String receiverId = widget.receiverId == widget.currentuserId
//           ? widget.senderId!
//           : widget.receiverId!;
//       onChatAdd(
//         receiverId: receiverId,
//         message: '',
//         senderId: widget.senderId,
//         messageprovider: Provider.of<MessageProvider>(context, listen: false),
//         imageFile: _selectedImage,
//       );
//     }
//   }

//   void _showImagePicker() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Select Image Source'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera),
//               title: Text('Camera'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo),
//               title: Text('Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
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
//           child: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         title: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProfileScreen(),
//               ),
//             );
//           },
//           child: Text(
//             widget.currentuserId == widget.senderId.toString()
//                 ? widget.receiverName.toString()
//                 : widget.senderName.toString(),
//             style: TextStyle(
//               fontFamily: "BankGothic",
//               color: Colors.white,
//               fontSize: 20.sp,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//         actions: const [
//           IconButton(
//             onPressed: null,
//             icon: Icon(
//               Icons.menu,
//               color: Colors.black,
//             ),
//           )
//         ],
//       ),
//       body: Consumer<MessageProvider>(
//         builder: (context, messageprovider, _) {
//           return Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                   bottom: 80.h,
//                   left: 16.w,
//                   right: 16.w,
//                 ),
//                 child: Builder(builder: (context) {
//                   return ListView.builder(
//                     controller: _scrollController,
//                     reverse: true,
//                     itemCount: messageprovider.chatList.length,
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       var message = messageprovider.chatList[index];
//                       log('message response===>>>>$message');
//                       log('message chat===>>>>$pref');
//                       bool isSender = message.senderId == senderId;

//                       return Align(
//                         alignment: isSender
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: EdgeInsets.only(
//                             top: 10.h,
//                             left: isSender ? 100.w : 0,
//                             right: isSender ? 0 : 100.w,
//                           ),
//                           child: ChatBubble(
//                             elevation: 1,
//                             clipper: ChatBubbleClipper5(
//                               type: isSender
//                                   ? BubbleType.sendBubble
//                                   : BubbleType.receiverBubble,
//                             ),
//                             backGroundColor: isSender ? Colors.white : primary,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       if (message.imageUrl != null &&
//                                           message.imageUrl!.isNotEmpty)
//                                         Image.file(
//                                           File(message.imageUrl!),
//                                           height: 150,
//                                           width: 150,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       if (message.message != null &&
//                                           message.message!.isNotEmpty)
//                                         Expanded(
//                                           child: Text(
//                                             message.message ?? '',
//                                             style: TextStyle(
//                                               color: isSender
//                                                   ? primary
//                                                   : Colors.white,
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                         ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text(
//                                         message.datetime != null
//                                             ? DateFormat('HH:mm').format(
//                                                 DateFormat('dd-MM-yyyy HH:mm')
//                                                     .parse(message.datetime!))
//                                             : 'Invalid date',
//                                         style: TextStyle(
//                                           color:
//                                               isSender ? primary : Colors.white,
//                                           fontSize: 12.sp,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: 20.h) +
//                       EdgeInsets.symmetric(
//                         horizontal: 16.w,
//                       ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: textcontroller,
//                           style: GoogleFonts.inter(
//                             color: Colors.white,
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           decoration: InputDecoration(
//                             suffixIcon: Padding(
//                               padding: const EdgeInsets.all(14.0),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   AppImage(
//                                     "assets/emoji.svg",
//                                     color: const Color(0xffA4A4A4),
//                                     height: 20.h,
//                                     width: 10.w,
//                                   ),
//                                   SizedBox(
//                                     width: 10.w,
//                                   ),
//                                   InkWell(
//                                     onTap: _showImagePicker,
//                                     child: AppImage(
//                                       "assets/gallery.svg",
//                                       color: const Color(0xffA4A4A4),
//                                       height: 20.h,
//                                       width: 10.w,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             isDense: true,
//                             hintText: "Message...",
//                             hintStyle: GoogleFonts.inter(
//                               color: const Color(0xffA4A4A4),
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.w400,
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide:
//                                   const BorderSide(color: Color(0xff323232)),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide:
//                                   const BorderSide(color: Color(0xff323232)),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide:
//                                   const BorderSide(color: Color(0xff323232)),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide:
//                                   const BorderSide(color: Color(0xff323232)),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide:
//                                   const BorderSide(color: Color(0xff323232)),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide:
//                                   const BorderSide(color: Color(0xff323232)),
//                             ),
//                             fillColor: const Color(0xff323232),
//                             filled: true,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 12.w,
//                       ),
//                       InkWell(
//                         onTap: () {},
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: const BoxDecoration(
//                             color: Color(0xff24D993),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const AppImage("assets/mic.svg"),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 12.w,
//                       ),
//                       Consumer<UsersProvider>(
//                         builder: (context, value, child) {
//                           return InkWell(
//                             onTap: () {
//                               log('currentuserId====>>>>${widget.currentuserId}');
//                               log('senderID==${widget.senderId}');
//                               log('receiverID==$receiverId1');
//                               String senderId = widget.receiverId.toString();
//                               String receiverId =
//                                   (senderId == widget.currentuserId)
//                                       ? widget.senderId.toString()
//                                       : widget.receiverId.toString();
//                               setState(() {
//                                 var newMessage = MessageModel(
//                                   senderId: senderId,
//                                   receiverId: receiverId,
//                                   message: textcontroller.text,
//                                   datetime: DateTime.now().toString(),
//                                   filename: '',
//                                 );
//                                 messageprovider.chatList.insert(0, newMessage);
//                               });
//                               onChatAdd(
//                                   receiverId: receiverId,
//                                   message: textcontroller.text,
//                                   senderId: senderId,
//                                   messageprovider: Provider.of<MessageProvider>(
//                                       context,
//                                       listen: false));
//                               log('message response ====>>>>${messageprovider.chatList}');
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(15),
//                               decoration: const BoxDecoration(
//                                 color: Color(0xff24D993),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const AppImage("assets/ic_send.svg"),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Future<void> onChatAdd({
//     required String receiverId,
//     required String message,
//     required String senderId,
//     required MessageProvider messageprovider,
//     File? imageFile,
//     File? videoFile,
//   }) async {
//     try {
//       var actualSenderId = pref!.getString(userIdKey) ?? '';
//       if (actualSenderId.isEmpty) {
//         throw Exception('Sender ID is empty');
//       }

//       String? filename;
//       if (imageFile != null) {
//         filename = imageFile.path;
//       } else if (videoFile != null) {
//         filename = videoFile.path;
//       }

//       // Ensure at least a message or filename is provided
//       if (message.isEmpty && filename == null) {
//         throw Exception('Message or Attachment is required');
//       }

//       var data = {
//         'sender_id': actualSenderId,
//         'receiver_id': receiverId,
//         'message': message,
//         'filename': filename ?? '',
//       };

//       log('Sending data: $data');

//       await messageprovider.addChat(context: context, data: data);

//       // Add the message to the chat list
//       if (filename != null) {
//         var newMessage = MessageModel(
//           senderId: senderId,
//           receiverId: receiverId,
//           message: '',
//           datetime: DateTime.now().toString(),
//           filename: filename,
//         );
//         messageprovider.chatList.insert(0, newMessage);
//       } else if (message.isNotEmpty) {
//         var newMessage = MessageModel(
//           senderId: senderId,
//           receiverId: receiverId,
//           message: message,
//           datetime: DateTime.now().toString(),
//           filename: '',
//         );
//         messageprovider.chatList.insert(0, newMessage);
//       }

//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: Duration(seconds: 0),
//         curve: Curves.easeOut,
//       );

//       textcontroller.clear();
//     } catch (error) {
//       log('Error sending message: $error');
//     }
//   }
// }

