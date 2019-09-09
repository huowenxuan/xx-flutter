import "package:flutter/material.dart";
import 'package:flutter_ui_nice/util/SizeUtil.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/Request.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter_ui_nice/component/TopTitleBar.dart';
import 'package:flutter_ui_nice/page/page_const.dart';
import 'package:intl/intl.dart';

class NoteListPage extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<NoteListPage> {
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

  _formatTime(item) {
    formatTs(ts) {
      return DateFormat('y/M/d HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(item['end']));
    }

    String show = '';
    if (item['start'] != null) {
      show += formatTs(item['start']) + ' - ';
    }
    show += formatTs(item['end']);
    return show;
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
      var start = item['start'];
      var end = item['end'];

      list[i] = {
        'id': item['id'],
        'header': header,
        'start': start,
        'end': end,
        'text': item['text'],
        "chars": item['text'].length.toString(),
        "chat": "67",
        "share": "12",
      };
    }
    return list;
  }

  Future<void> initData() async {
    try {
      var response = await Request.get('http://huowenxuan.zicp.vip/notes');
      setState(() {
        _offset = 0;
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
          'http://huowenxuan.zicp.vip/notes?limit=$limit&offset=$_offset');
      setState(() {
        _offset += limit;
        _data.addAll(_formatList(response['data']));
        _isPerformingRequest = false;
      });
    }
  }

  _toDetail(item, isEditMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(
            data: item,
            isEditMode: isEditMode,
            onSuccess: () {
              this.initData();
            }),
      ),
    );
  }

  Widget _textBack(content,
          {color = TEXT_BLACK_LIGHT, size = 12, isBold = false}) =>
      Text(
        content.toString(),
        maxLines: 3,
        overflow: TextOverflow.visible,
        style: TextStyle(
            color: color,
            fontSize: size + .0,
            fontWeight: isBold ? FontWeight.w700 : null),
      );

  Widget _itemAction(item, index) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _actionChild(Icons.format_size, item["chars"], null),
          SizedBox(width: SizeUtil.getAxisX(75.0)),
          _actionChild(Icons.edit, "", () {
            _toDetail(item, true);
          }),
          SizedBox(width: SizeUtil.getAxisX(75.0)),
          _actionChild(Icons.restore_from_trash, "", () {
            showDialog(
                context: context,
                builder: (context) {
                  return new AlertDialog(
                    title: new Text("Delete?"),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () async {
                          await Request.delete(
                              'http://huowenxuan.zicp.vip/note/' + item['id'],
                              null);
                          _data.removeAt(index);
                          setState(() => _data = _data);
                          Navigator.of(context).pop();
                        },
                        child: Text('Yes',
                            style: new TextStyle(color: Colors.red)),
                      ),
                      new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No',
                            style: new TextStyle(color: Colors.black)),
                      ),
                    ],
                  );
                });
          }),
        ],
      );

  Widget _actionChild(icon, value, onPress) => Container(
        width: 70,
        height: 25,
        child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: onPress,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: TEXT_BLACK_LIGHT,
                size: SizeUtil.getAxisBoth(30.0),
              ),
              SizedBox(width: SizeUtil.getAxisX(20.0)),
              _textBack(value),
            ],
          ),
        ),
      );

  Widget _listItem(item, index) => Container(
        constraints: BoxConstraints.expand(height: 170),
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              _toDetail(item, false);
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
                // 头像+时间
                Positioned(
                  left: SizeUtil.getAxisX(25.0),
                  top: SizeUtil.getAxisY(46.0),
                  child: Container(
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
                        _textBack(_formatTime(item), size: 14),
                      ],
                    ),
                  ),
                ),
                // 小按钮
                Positioned(
                  left: SizeUtil.getAxisX(142.0),
                  bottom: SizeUtil.getAxisY(35.0),
                  child: _itemAction(item, index),
                ),
                // 文本
                Positioned(
                  top: SizeUtil.getAxisY(118.0),
                  left: SizeUtil.getAxisX(160.0),
                  right: 30,
                  height: SizeUtil.getAxisY(70.0),
                  child: _textBack(item['text'], size: 13),
                ),
              ],
            )),
      );

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
              title: 'NOTE',
              leftImage: OldFeedImage.more_circle,
              rightImage: OldFeedImage.feed_add,
              rightPress: () {
                _toDetail(null, true);
              },
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
