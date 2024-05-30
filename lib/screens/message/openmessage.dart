import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/mesageModel.dart';
import 'package:touchmaster/providers/messageProviders.dart';
import 'package:touchmaster/providers/userProvider.dart';
import 'package:touchmaster/utils/color.dart';
import 'package:touchmaster/utils/constant.dart';
import 'package:touchmaster/utils/size_extension.dart';
import '/app_image.dart';
import '/screens/account/profile.dart';

class OpenMessageScreen extends StatefulWidget {
  MessageModel? messageModel;
  String? senderName;
  String? receiverName;
  String? receiverId;
  String senderId;
  String? currentuserId;

  OpenMessageScreen({
    Key? key,
    required this.receiverId,
    required this.senderId,
    this.currentuserId,
    this.senderName,
    this.receiverName,
    this.messageModel,
  }) : super(key: key);

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
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  _OpenMessageScreenState({required this.receiverId1, required this.senderId});

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      print("Message :-> ${message.data}");
    });
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      print("initial Message :-> ${value?.data}");
    });

    SharedPreferences.getInstance().then((value) {
      setState(() {
        pref = value;
        initFun();
      });
    }).catchError((error) {
      print('Error initializing SharedPreferences: $error');
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        _onSendImage();
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  void _onSendImage() {
    if (_selectedImage != null) {
      String receiverId = widget.receiverId == widget.currentuserId
          ? widget.senderId!
          : widget.receiverId!;
      onChatAdd(
        receiverId: receiverId,
        message: '',
        senderId: widget.senderId,
        messageprovider: Provider.of<MessageProvider>(context, listen: false),
        imageFile: _selectedImage,
      );
    }
  }

  void _showImagePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
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
                          bool isSender = message.senderId == senderId;
                          bool isImage = message.imageUrl != null &&
                              message.imageUrl!.isNotEmpty;

                          return Align(
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 10.h,
                                right: isSender && !isImage ? 100.w : 0,
                                left: !isSender && !isImage ? 100.w : 0,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          if (isImage &&
                                              Uri.parse(message.imageUrl!)
                                                  .isAbsolute)
                                            Image.network(
                                              message.imageUrl!,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          if (!isImage &&
                                              message.message != null &&
                                              message.message!.isNotEmpty)
                                            Expanded(
                                              child: Text(
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
                                            message.datetime != null
                                                ? DateFormat('HH:mm').format(
                                                    DateFormat(
                                                            'dd-MM-yyyy HH:mm')
                                                        .parse(
                                                            message.datetime!))
                                                : 'Invalid date',
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
                                    InkWell(
                                      onTap: _showImagePicker,
                                      child: AppImage(
                                        "assets/gallery.svg",
                                        color: const Color(0xffA4A4A4),
                                        height: 20.h,
                                        width: 10.w,
                                      ),
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
                                String senderId = widget.receiverId.toString();
                                String receiverId =
                                    (senderId == widget.currentuserId)
                                        ? widget.senderId.toString()
                                        : widget.receiverId.toString();
                                setState(() {
                                  var newMessage = MessageModel(
                                    senderId: senderId,
                                    receiverId: receiverId,
                                    message: textcontroller.text,
                                    datetime: DateTime.now().toString(),
                                    filename: '',
                                  );
                                  messageprovider.chatList
                                      .insert(0, newMessage);
                                });
                                onChatAdd(
                                    receiverId: receiverId,
                                    message: textcontroller.text,
                                    senderId: senderId,
                                    messageprovider:
                                        Provider.of<MessageProvider>(context,
                                            listen: false));
                                log('message response ====>>>>${messageprovider.chatList}');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  color: Color(0xff24D993),
                                  shape: BoxShape.circle,
                                ),
                                child: const AppImage("assets/ic_send.svg"),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }

  Future<void> onChatAdd({
    required String receiverId,
    required String message,
    required String senderId,
    required MessageProvider messageprovider,
    File? imageFile,
    File? videoFile,
  }) async {
    try {
      var actualSenderId = pref!.getString(userIdKey) ?? '';
      if (actualSenderId.isEmpty) {
        throw Exception('Sender ID is empty');
      }

      var data = {
        'sender_id': actualSenderId,
        'receiver_id': receiverId,
        'message': message,
        'filename': imageFile != null
            ? imageFile.path
            : (videoFile != null ? videoFile.path : ''),
      };
      log('data response ===>>>$data');

      await messageprovider.editProfileBG(
        context: context,
        filePath: imageFile!.path,
        data: {},
      );

      if (imageFile != null) {
        var newMessage = MessageModel(
          senderId: senderId,
          receiverId: receiverId,
          message: '',
          datetime: DateTime.now().toString(),
          filename: imageFile.path,
        );
        setState(() {
          messageprovider.chatList.insert(0, newMessage);
        });
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 0),
        curve: Curves.easeOut,
      );

      textcontroller.clear();
    } catch (error) {
      log('Error sending message: $error');
    }
  }
}
