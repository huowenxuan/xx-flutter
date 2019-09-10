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
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/Util.dart';

class PhotosPage extends StatefulWidget {
  final photos; // 用来储存传递过来的值
  final int index;

  // 类的构造器，用来接收传递的值
  PhotosPage({Key key, this.photos, this.index}) : super(key: key);

  @override
  _FeedState createState() => new _FeedState();
}

class _FeedState extends State<PhotosPage> with TickerProviderStateMixin {
  var _photos = [];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _photos = widget.photos;
      int index = widget.index;
      if (index > 0) {
        _index = index;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            heroTag: 'download',
            child: Icon(Icons.file_download),
            backgroundColor: YELLOW,
            onPressed: () {
              saveNetworkImage(_photos[_index]);
            }),
        body: ConstrainedBox(
            //通过ConstrainedBox来确保Stack占满屏幕
            constraints: BoxConstraints.expand(),
            child: Stack(
              alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Container(
                    child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(_photos[index]),
                      initialScale: PhotoViewComputedScale.contained * 1,
                      heroAttributes: PhotoViewHeroAttributes(tag: _photos[index])
                    );
                  },
                  itemCount: _photos.length,
                  loadingChild: Container(
                      color: Colors.black,
                      child: Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: const CircularProgressIndicator(
                              backgroundColor: RED),
                        ),
                      )),
//        backgroundDecoration: BoxDecoration(gradient: GradientUtil.yellowGreen()),
                  pageController: PageController(initialPage: _index),
                  onPageChanged: (index) {
                    _index = index;
                  },
                )),
                // 绝对布局
                Positioned(
                  left: 20,
                  top: 20,
                  child: FloatingActionButton(
                    heroTag: 'back',
                      mini: true,
                      child: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            )));
  }
}
