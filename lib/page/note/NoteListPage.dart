import "package:flutter/material.dart";
import 'package:flutter_ui_nice/util/SizeUtil.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/Request.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter_ui_nice/component/TopTitleBar.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_ui_nice/page/page_const.dart';

class NoteListPage extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<NoteListPage> {
  var _data = [];

  Widget _textBack(content,
          {color = TEXT_BLACK_LIGHT, size = 12, isBold = false}) =>
      Text(
        content,
        maxLines: 3,
        overflow: TextOverflow.visible,
        style: TextStyle(
            color: color,
            fontSize: size + .0,
            fontWeight: isBold ? FontWeight.w700 : null),
      );

  Widget _itemHeader(item) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              item["header"],
              height: SizeUtil.getAxisBoth(84.0),
              width: SizeUtil.getAxisBoth(84.0),
            ),
            SizedBox(
              width: SizeUtil.getAxisX(51.0),
            ),
            _textBack(item["time"], size: 14),
          ],
        ),
      );

//
  Widget _itemAction(item) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _actionChild(Icons.format_size, item["chars"], null),
          SizedBox(width: SizeUtil.getAxisX(75.0)),
          _actionChild(Icons.edit, "", null),
          SizedBox(width: SizeUtil.getAxisX(75.0)),
          _actionChild(Icons.restore_from_trash, "", (){
            print('a');
          }),
        ],
      );

  Widget _actionChild(icon, value, onPress) => Row(
    children: <Widget>[
      Icon(
        icon,
        color: TEXT_BLACK_LIGHT,
        size: SizeUtil.getAxisBoth(30.0),
      ),
      SizedBox(width: SizeUtil.getAxisX(20.0)),
      _textBack(value),
    ],
  );

  Widget _listItem(item, index) => Container(
        constraints: BoxConstraints.expand(height: 180),
        margin: EdgeInsets.only(top: SizeUtil.getAxisY(40.0)),
        child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarkdownPage(
                    data: item
                  ),
                ),
              );
            },
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: index % 2 != 1
                          ? GradientUtil.red()
                          : GradientUtil.blue(),
                      borderRadius: BorderRadius.circular(
                        SizeUtil.getAxisBoth(22.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x11000000), offset: Offset(0.1, 4.0))
                      ]),
                  margin: EdgeInsets.only(
                      left: SizeUtil.getAxisX(80.0),
                      right: SizeUtil.getAxisX(40.0)),
                ),
                Positioned(
                  left: SizeUtil.getAxisX(25.0),
                  top: SizeUtil.getAxisY(46.0),
                  child: _itemHeader(item),
                ),
                Positioned(
                  left: SizeUtil.getAxisX(162.0),
                  bottom: SizeUtil.getAxisY(45.0),
                  child: _itemAction(item),
                ),
                Positioned(
                  top: SizeUtil.getAxisY(156.0),
                  left: SizeUtil.getAxisX(160.0),
                  height: SizeUtil.getAxisY(70.0),
                  child: _textBack(item['text'], size: 13),
                ),
              ],
            )),
      );

  Widget _body() => ListView.builder(
        itemBuilder: (context, index) {
          var item = _data[index % _data.length];
          return _listItem(item, index);
        },
        itemCount: _data.length,
        padding: EdgeInsets.only(top: 0.1),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GradientUtil.yellowGreen()),
        child: Column(
          children: <Widget>[
            TopTitleBar(
              leftImage: OldFeedImage.more_circle,
              rightImage: OldFeedImage.feed_add,
            ),
            Expanded(
              child: _body(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.initData();
  }

  initData() async {
    var data = await Request.get('http://huowenxuan.zicp.vip/notes');
    data = data['data'];

    for (var i = 0; i < data.length; i++) {
      var item = data[i];
      var header = '';
      switch (i % 3) {
        case 0:
          header = OldFeedImage.feed13_header1;
          break;
        case 1:
          header = OldFeedImage.feed13_header2;
          break;
        case 2:
          header = OldFeedImage.feed13_header3;
          break;
      }
      data[i] = {
        'id': item['id'],
        'header': header,
        'time':
            DateUtil.formatDateMs(item['end'], format: "yyyy/MM/dd HH:mm:ss"),
        'text': item['text'],
        "chars": item['text'].length.toString(),
        "chat": "67",
        "share": "12",
      };
    }

    setState(() {
      _data = data;
    });
  }
}
