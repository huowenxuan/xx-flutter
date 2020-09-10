import "package:flutter/material.dart";
import 'package:flutter_ui_nice/component/TopTitleBar.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/util/Request.dart';
import 'package:image_save/image_save.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'dart:async';
import 'package:flutter_ui_nice/util/Util.dart';
import 'package:flutter_ui_nice/page/page_const.dart';

class VogueDetailPage extends StatefulWidget {
  final String id; // 用来储存传递过来的值
  // 类的构造器，用来接收传递的值
  VogueDetailPage({Key key, this.id}) : super(key: key);

  @override
  _FeedState createState() => new _FeedState();
}

class _FeedState extends State<VogueDetailPage> with TickerProviderStateMixin {
  var _data = {};
  var _images = [];
  var _screenWeight;
  var _isLoading = false;
  AnimationController _refreshController;
  Duration _resetDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      this.initData();
    });

    _refreshController =
        AnimationController(duration: _resetDuration, vsync: this);
    _refreshController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
//        print("status is completed");
        _refreshController.reset();
        if (_isLoading) {
          _refreshController.forward();
        }
      } else if (status == AnimationStatus.dismissed) {
        //动画从 controller.reverse() 反向执行 结束时会回调此方法
//        print("status is dismissed");
      } else if (status == AnimationStatus.forward) {
//        print("status is forward");
        //执行 controller.forward() 会回调此状态
      } else if (status == AnimationStatus.reverse) {
        //执行 controller.reverse() 会回调此状态
//        print("status is reverse");
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  _startRefreshAnim() {
    //开启
    if (_refreshController != null) _refreshController.forward();
  }

  initData() async {
    setState(() => _isLoading = true);
    _startRefreshAnim();

    String url = Request.API + 'vogue/' + widget._id;
    var data = await Request.get(url);
    data = data['data'];

    var images = [];
    for (var i = 0; i < data['images'].length; i++) {
      var item = data['images'][i];
      if (i % 3 == 0) {
        images.add([]);
        images[(i / 3).floor()] = [item];
      } else {
        images[(i / 3).floor()].add(item);
      }
    }

    setState(() {
      _data = data;
      _images = images;
      _isLoading = false;
    });
    print('加载完成');
  }

  _toPhoto(index) {
    print(index);
    var list = [];
    for (var item in _data['images']) {
      list.add(item['url']);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotosPage(
          photos: list,
          index: index as int,
        ),
      ),
    );
  }

  Widget _itemImages(item, index) => Container(
        alignment: AlignmentDirectional.center,
        child: ListView.builder(
          itemBuilder: (context, index2) {
            var img = item[index2]['thumbnails'];
            return Container(
                margin: EdgeInsets.only(
                  left: 0.5,
                  right: 0.5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          _toPhoto(index * 3 + index2);
                        },
                        child: Image.network(img,
                            fit: BoxFit.contain,
                            width: _screenWeight / 3 - 1,
                            height: (_screenWeight / 3) / 0.68),
                      ),
                      width: _screenWeight / 3 - 1,
                      height: (_screenWeight / 3) / 0.68,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: FlatButton(
                          onPressed: () {
                            var downloadUrl = item[index2]['url'];
                            saveNetworkImage(downloadUrl);
                            print(downloadUrl);
                          },
                          padding: EdgeInsets.all(0),
                          child: Text(
                            "DOWNLOAD",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        )),
                  ],
                ));
          },
          itemCount: item.length,
          scrollDirection: Axis.horizontal,
        ),
      );

  Widget _listItem(item, index) => Container(
        constraints: BoxConstraints.expand(
            width: _screenWeight / 3 - 2,
            height: (_screenWeight / 3 - 2) * 1.7 + 10 + 25),
        margin: EdgeInsets.only(top: 0, bottom: 0),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.center,
              child: _itemImages(item, index),
            )
          ],
        ),
      );

  Widget _body() => ListView.builder(
        itemBuilder: (context, index) {
          var item = _images[index % _images.length];
          return _listItem(item, index);
        },
        itemCount: _images.length,
        padding: EdgeInsets.only(top: 0.1),
      );

  @override
  Widget build(BuildContext context) {
    _screenWeight = MediaQuery.of(context).size.width;
    String title = _data['title'] != null ? _data['title'] : '';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: RotationTransition(
            child: Icon(Icons.refresh),
            alignment: Alignment.center,
            turns: _refreshController,
          ),
          onPressed: () {
            initData();
          }),
      body: Container(
        decoration: BoxDecoration(gradient: GradientUtil.yellowGreen()),
        child: Column(
          children: <Widget>[
            TopTitleBar(
              title: title,
              rightImage: OldFeedImage.search_circle,
              rightPress: () async {
                var text =
                    _data['category'] + ' ' + _data['title'] + '\n\n#色彩图册#';
                Clipboard.setData(ClipboardData(text: text));
                text = (await Clipboard.getData(Clipboard.kTextPlain)).text;
                print(text);
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
