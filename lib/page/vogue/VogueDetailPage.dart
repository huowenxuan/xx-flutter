import "package:flutter/material.dart";
import 'top_title.dart';
import 'package:flutter_ui_nice/util/SizeUtil.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'feed_const.dart';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/Request.dart';

class VogueDetailPage extends StatefulWidget {
  final String id; // 用来储存传递过来的值
  // 类的构造器，用来接收传递的值
  VogueDetailPage({Key key, this.id}) : super(key: key);

  @override
  _FeedState createState() => new _FeedState();
}

class _FeedState extends State<VogueDetailPage> {
  var _data = [];
  var _arguments;
  String _id;

  Widget _textBack(content,
          {color = TEXT_BLACK_LIGHT,
          size = TEXT_SMALL_2_SIZE,
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
                _textBack(item["name"], size: TEXT_SMALL_3_SIZE, isBold: true),
                SizedBox(
                  height: SizeUtil.getAxisY(13.0),
                ),
                _textBack(item["desc"], size: TEXT_NORMAL_SIZE),
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
        child: _textBack(item["desc"], size: TEXT_SMALL_3_SIZE),
      );

  Widget _itemImages(item) => Container(
        alignment: AlignmentDirectional.center,
        constraints: BoxConstraints.expand(height: SizeUtil.getAxisY(270.0)),
        child: ListView.builder(
          itemBuilder: (context, index) {
            var img = item["images"][index];
            double width = 100;
            return Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    img,
                    fit: BoxFit.contain,
                  ),
                ));
          },
          itemCount: item["images"].length,
          scrollDirection: Axis.horizontal,
        ),
      );

  Widget _listItem(item, index) => Container(
        constraints: BoxConstraints.expand(
          height: SizeUtil.getAxisY(item["images"].length > 0 ? 550 : 200),
        ),
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: <Widget>[
            _backCard(index % 2 == 0),
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
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: AlignmentDirectional.center,
              child: _itemImages(item),
            )
          ],
        ),
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
    _arguments = ModalRoute.of(context).settings.arguments;
    _id = _arguments['id'];
    print(_id);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GradientUtil.yellowGreen()),
        child: Column(
          children: <Widget>[
            TopTitleBar(
              rightImage: FeedImage.feed_add,
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
    print(widget.id);
//    String url = 'http://huowenxuan.zicp.vip/vogue/' + widget.id;
//    var data = await Request.get(url);
//    data = data['data'];
//    print(data);
//
//    setState(() {
//      _data = data;
//    });
  }
}
