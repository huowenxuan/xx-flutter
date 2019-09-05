import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_ui_nice/component/TopTitleBar.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_nice/util/Request.dart';

class NoteEditPage extends StatefulWidget {
  final data; // 用来储存传递过来的值
  // 类的构造器，用来接收传递的值
  NoteEditPage({Key key, this.data}) : super(key: key);

  @override
  NoteEditPageState createState() => NoteEditPageState();
}

class NoteEditPageState extends State<NoteEditPage> {
  String _input = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _input = widget.data != null ? widget.data['text'] : "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GradientUtil.yellowGreen()),
        child: Column(
          children: <Widget>[
            TopTitleBar(
              title: "EDIT",
              leftImage: OldFeedImage.more_circle,
              rightImage: OldFeedImage.feed_add,
              rightPress: () async {
                var postData = {
                  'user_id': '1',
                  'text': _input,
                  'end': 1567675138041
                };
                if (widget.data != null) {
                  await Request.put('http://huowenxuan.zicp.vip/note/' + widget.data['id'], postData);
                } else {
                  await Request.post('http://huowenxuan.zicp.vip/note', postData);
                }
                Navigator.pop(context);
//                Clipboard.setData(ClipboardData(text: widget.data['text']));
              },
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLines: 300,
                controller: new TextEditingController(text: this._input),
                onChanged: (val) {
                  setState(() {
                    this._input = val;
                  });
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

}
