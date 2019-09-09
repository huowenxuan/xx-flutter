import "package:flutter/material.dart";
import 'package:flutter_ui_nice/page/page_const.dart';
import 'package:flutter_ui_nice/component/TopTitleBar.dart';
import 'package:flutter_ui_nice/util/SizeUtil.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/Request.dart';
import 'package:flutter_ui_nice/const/images_const.dart';

class VogueListPage extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<VogueListPage> {
  var _data = [];
  int _offset = 0;
  bool _isPerformingRequest = false;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 50) {
        _appendData();
      }
    });
    this.initData();
  }

  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _formatList(list) {
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
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
      var imageUrls = [];
      for (var image in item['images']) {
        imageUrls.add(image['thumbnails']);
      }
      list[i] = {
        'id': item['id'],
        'header': header,
        'name': item['title'],
        'desc': item['category'],
        "like": "123",
        "chat": "67",
        "share": "12",
        'images': imageUrls
      };
    }
    return list;
  }

  Future<void> initData() async {
    try {
      var response = await Request.get(Request.API + 'vogues');
      setState(() {
        _offset = 10;
        _data = _formatList(response['data']);
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text(e.toString(),
                  style: new TextStyle(color: Colors.red)),
            );
          });
      return;
    }
  }

  _appendData() async {
    if (!_isPerformingRequest) {
      setState(() => _isPerformingRequest = true);
      int limit = 10;
      var response = await Request.get(
          Request.API +'vogues?limit=$limit&offset=$_offset');
      setState(() {
        _offset += limit;
        _data.addAll(_formatList(response['data']));
        _isPerformingRequest = false;
      });
    }
  }

  Widget _textBack(content,
          {color = TEXT_BLACK_LIGHT, size = 12, isBold = false}) =>
      Text(
        content,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _textBack(item["name"], size: 13, isBold: true),
                SizedBox(
                  height: SizeUtil.getAxisY(13.0),
                ),
                _textBack(item["desc"], size: 14),
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
      child: FlatButton(
        padding: EdgeInsets.only(left: 0, right: 0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VogueDetailPage(
                id: item['id'],
              ),
            ),
          );
//          Navigator.pushNamed(context, 'VOGUE_DETAIL', arguments: {
//            'id': item['id']
//          });
        },
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
      ));

  Widget _body() => RefreshIndicator(
      onRefresh: initData,
      backgroundColor: YELLOW,
      color: RED,
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return _listItem(_data[index], index);
        },
        itemCount: _data.length,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GradientUtil.yellowGreen()),
        child: Column(
          children: <Widget>[
            TopTitleBar(
              title: 'VOGUE',
            ),
            Expanded(
              child: _body(),
            )
          ],
        ),
      ),
    );
  }
}
