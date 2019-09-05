import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_ui_nice/component/TopTitleBar.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter/services.dart';

class MarkdownPage extends StatefulWidget {
  final data; // 用来储存传递过来的值
  // 类的构造器，用来接收传递的值
  MarkdownPage({Key key, this.data}) : super(key: key);

  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MarkdownPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GradientUtil.yellowGreen()),
        child: Column(
          children: <Widget>[
            TopTitleBar(
              title: "REVIEW",
              leftImage: OldFeedImage.more_circle,
              rightImage: OldFeedImage.feed_add,
              rightPress: () {
                Clipboard.setData(ClipboardData(text: widget.data['text']));
              },
            ),
            Expanded(
              child: Markdown(data: widget.data['text']),
            )
          ],
        ),
      ),
    );
  }
}