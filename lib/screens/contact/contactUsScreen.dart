import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/color.dart';
import '../../utils/constant.dart';
import '../../utils/customLoader.dart';
import '/providers/contactUsProvider.dart';
import '/utils/commonMethod.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  int selectQuery = -1;
  double height = 0;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Contact Us'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Consumer<ContactUsProvider>(builder: (context, data, child) {
          return ListView(
            children: [
              Text(
                "Contact Support",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              textField(
                  context: context,
                  controller: data.nameController,
                  hint: 'Enter Name',
                  index: 0),
              SizedBox(
                height: 30,
              ),
              textField(
                  context: context,
                  controller: data.phoneController,
                  hint: 'Enter Mobile',
                  index: 1),
              SizedBox(
                height: 30,
              ),
              textField(
                  context: context,
                  controller: data.emailController,
                  hint: 'Enter Email',
                  index: 2),
              SizedBox(
                height: 30,
              ),
              textField(
                  context: context,
                  controller: data.queryController,
                  hint: 'Select Query',
                  index: 3),
              SizedBox(
                height: 30,
              ),
              textField(
                  context: context,
                  controller: data.messageController,
                  hint: 'Type your message here',
                  index: 4),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: button(label: 'Submit', isNext: false, onTap: onSubmit),
              ),
              SizedBox(
                height: 30,
              )
            ],
          );
        }),
      ),
    );
  }

  Widget textField(
          {required BuildContext context,
          required TextEditingController controller,
          required String hint,
          required int index}) =>
      Container(
        child: TextFormField(
          readOnly: index == 3 ? true : false,
          onTap: index == 3
              ? () {
                  showQuerySheet(context: context);
                }
              : null,
          keyboardType: (index == 0)
              ? TextInputType.name
              : (index == 1)
                  ? TextInputType.phone
                  : (index == 2)
                      ? TextInputType.emailAddress
                      : TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: white,
          ),
          maxLines: index == 4 ? 9 : 1,
          minLines: index == 4 ? 4 : 1,
          controller: controller,
          inputFormatters: [
            if (index == 0) LengthLimitingTextInputFormatter(50),
            if (index == 2) LengthLimitingTextInputFormatter(50),
            if (index == 1) LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
              hintText: hint,
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
      );

  Future<void> onSubmit() async {
    var pro = Provider.of<ContactUsProvider>(context, listen: false);
    Map<String, String> data = {};
    if (pro.nameController.text.isEmpty) {
      customToast(context: context, msg: 'Name Required', type: 0);
    } else if (pro.emailController.text.isEmpty) {
      customToast(context: context, msg: 'Email ID required', type: 0);
    } else if (!emailExpression.hasMatch(pro.emailController.text)) {
      customToast(context: context, msg: 'Enter valid Email ID', type: 0);
    } else if (pro.phoneController.text.isEmpty) {
      customToast(context: context, msg: 'Phone number required', type: 0);
    } else if (pro.messageController.text.isEmpty) {
      customToast(context: context, msg: 'Please type message', type: 0);
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      data = {
        'user_id': pref.getString(userIdKey) ?? '',
        'name': pro.nameController.text,
        'email': pro.emailController.text,
        'contact_number': pro.phoneController.text,
        'message': pro.messageController.text,
        'type': pro.queryController.text,
      };

      pro.submitContact(context: context, data: data).then((value) {
        if (pro.isDone) {
          // commonAlert(context, data);
          navPop(context: context);
        }
      });
    }

    log('RegData------------>>>>$data');
  }

  Future<void> showQuerySheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Consumer<ContactUsProvider>(builder: (context, data, child) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 500,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              navPop(context: context);
                            },
                            icon: Icon(
                              Icons.clear,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        height: 350,
                        child: ListView.separated(
                          itemCount: data.queries.length,
                          itemBuilder: (context, index) {
                            var item = data.queries[index];
                            return Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: grey,
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                title: Text(
                                  capitalize(item.title),
                                  style: TextStyle(color: white),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    state(() {
                                      selectQuery = index;
                                      data.queryController.text = item.title;
                                    });
                                    navPop(context: context);
                                  },
                                  icon: Icon(
                                    (selectQuery == index)
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: primary,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              );
            });
          });
        });
  }
}
