import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../utils/color.dart';
import '/model/contentModel.dart';
import '/utils/commonMethod.dart';

class ContentScreen extends StatefulWidget {
  final ContentModel content;

  const ContentScreen({super.key, required this.content});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar,
      body: body,
    );
  }

  AppBar get appBar => AppBar(
        leading: IconButton(
          onPressed: () {
            navPop(context: context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          widget.content.title,
          style: TextStyle(color: white),
        ),
        centerTitle: true,
      );

  Widget get body => Container(
        padding: EdgeInsets.all(15),
        child: HtmlWidget(
          widget.content.content,
          textStyle: TextStyle(fontSize: 15, color: white),
        ),
      );
}
