import "package:flutter/material.dart";
import 'package:flutter_ui_nice/component/TopTitleBar.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/util/Request.dart';
import 'package:image_save/image_save.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_ui_nice/const/images_const.dart';

/*
TODO
刷新旋转icon
 */
class VogueDetailPage extends StatefulWidget {
  final String id; // 用来储存传递过来的值
  // 类的构造器，用来接收传递的值
  VogueDetailPage({Key key, this.id}) : super(key: key);

  @override
  _FeedState createState() => new _FeedState();
}

class _FeedState extends State<VogueDetailPage> {
  var _data = {};
  var _images = [];
  var _screenWeight;

  _saveImage(url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageSave.saveImage("jpg", Uint8List.fromList(response.data));
    print(result);
  }

  Widget _itemImages(item) => Container(
        alignment: AlignmentDirectional.center,
        child: ListView.builder(
          itemBuilder: (context, index) {
            var img = item[index]['thumbnails'];
            return Container(
                margin: EdgeInsets.only(
                  left: 0.5,
                  right: 0.5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.network(
                      img,
                      fit: BoxFit.contain,
                      width: _screenWeight / 3 - 1,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: FlatButton(
                          onPressed: () {
                            var downloadUrl = item[index]['url'];
                            _saveImage(downloadUrl);
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
              child: _itemImages(item),
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
          child: Icon(Icons.refresh),
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

  @override
  void initState() {
    super.initState();
    this.initData();
  }

  initData() async {
    String url = Request.API + 'vogue/' + widget.id;
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
    });
  }
}
