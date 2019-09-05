import 'dart:convert';

import "package:flutter/material.dart";
import 'top_title.dart';
import 'package:flutter_ui_nice/util/SizeUtil.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/Request.dart';
import 'package:flutter_ui_nice/const/images_const.dart';

class NoteListPage extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<NoteListPage> {
  var data = [];

  Widget _textBack(content,
          {color = TEXT_BLACK_LIGHT,
          size = 22,
          isBold = false}) =>
      Text(
        content,
        style: TextStyle(
            color: color,
            fontSize: SizeUtil.getAxisBoth(size),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _textBack(item["name"], size: 24, isBold: true),
                SizedBox(
                  height: SizeUtil.getAxisY(13.0),
                ),
                _textBack(item["time"], size: 26),
              ],
            )
          ],
        ),
      );

//
  Widget _itemAction(item) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _actionChild(Icons.favorite_border, item["like"]),
          SizedBox(width: SizeUtil.getAxisX(75.0)),
          _actionChild(Icons.chat, item["chat"]),
          SizedBox(width: SizeUtil.getAxisX(75.0)),
          _actionChild(Icons.share, item["share"]),
        ],
      );

  Widget _actionChild(icon, value) => Row(
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

  Widget _backCard(isEmpty) => Container(
        decoration: BoxDecoration(
            gradient: !isEmpty ? GradientUtil.red() : GradientUtil.blue(),
            borderRadius: BorderRadius.circular(
              SizeUtil.getAxisBoth(22.0),
            ),
            boxShadow: [
              BoxShadow(color: Color(0x11000000), offset: Offset(0.1, 4.0))
            ]),
        margin: EdgeInsets.only(
            left: SizeUtil.getAxisX(80.0), right: SizeUtil.getAxisX(40.0)),
      );

  Widget _itemText(item) => Container(
        child: _textBack(item["desc"], size: 24),
      );

  Widget _itemImages(item) => Container(
        alignment: AlignmentDirectional.center,
        constraints: BoxConstraints.expand(height: SizeUtil.getAxisY(170.0)),
        child: ListView.builder(
          itemBuilder: (context, index) {
            var img = item["images"][index];
            return Container(
              margin: EdgeInsets.only(
                left: SizeUtil.getAxisX(20.0),
                right: SizeUtil.getAxisX(20.0),
              ),
              child: Image.asset(
                img,
                width: SizeUtil.getAxisBoth(170.0),
                height: SizeUtil.getAxisBoth(170.0),
              ),
            );
          },
          itemCount: item["images"].length,
          scrollDirection: Axis.horizontal,
        ),
      );

  Widget _listItem(item) => Container(
        constraints: BoxConstraints.expand(
          height: SizeUtil.getAxisY(
              item["desc"].toString().isNotEmpty ? 350.0 : 469.0),
        ),
        margin: EdgeInsets.only(top: SizeUtil.getAxisY(40.0)),
        child: Stack(
          children: <Widget>[
            _backCard(item["desc"].toString().isEmpty),
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
            item["desc"].toString().isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: SizeUtil.getAxisY(20.0)),
                    alignment: AlignmentDirectional.center,
                    child: _itemImages(item),
                  )
                : Positioned(
                    top: SizeUtil.getAxisY(156.0),
                    left: SizeUtil.getAxisX(160.0),
                    height: SizeUtil.getAxisY(70.0),
                    child: _itemText(item),
                  ),
          ],
        ),
      );

  Widget _body() => ListView.builder(
        itemBuilder: (context, index) {
          var item = posts[index % posts.length];
          return _listItem(item);
        },
        itemCount: posts.length,
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
    setState(() {
      data = data;
    });
  }
}

const posts = [
  {
    "header": OldFeedImage.feed13_header1,
    "name": "Katherine Farmer",
    "time": "1 hour ago",
    "desc": "Decorate For Less With Art Posters",
    "like": "123",
    "chat": "67",
    "share": "12",
    "images": [
      OldFeedImage.feed13_pic1,
      OldFeedImage.feed13_pic2,
      OldFeedImage.feed13_pic3,
      OldFeedImage.feed13_pic4,
    ]
  },
  {
    "header": OldFeedImage.feed13_header2,
    "name": "Tyler Guerrero",
    "time": "2 hour ago",
    "desc": "",
    "like": "123",
    "chat": "67",
    "share": "12",
    "images": [
      OldFeedImage.feed13_pic1,
      OldFeedImage.feed13_pic2,
      OldFeedImage.feed13_pic3,
      OldFeedImage.feed13_pic4,
    ]
  },
  {
    "header": OldFeedImage.feed13_header3,
    "name": "Hettie Nguyen",
    "time": "3 hour ago",
    "desc": "Decorate For Less With Art Posters",
    "like": "123",
    "chat": "67",
    "share": "12",
    "images": [
      OldFeedImage.feed13_pic1,
      OldFeedImage.feed13_pic2,
      OldFeedImage.feed13_pic3,
      OldFeedImage.feed13_pic4,
    ]
  },
  {
    "header": OldFeedImage.feed13_header1,
    "name": "Katherine Farmer",
    "time": "4 hour ago",
    "desc": "",
    "like": "123",
    "chat": "67",
    "share": "12",
  }
];