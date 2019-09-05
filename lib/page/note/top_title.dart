///
/// Created by NieBin on 2018/12/26
/// Github: https://github.com/nb312
/// Email: niebin312@gmail.com
///
import "package:flutter/material.dart";
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/SizeUtil.dart';

class TopTitleBar extends StatelessWidget {
  TopTitleBar(
      {this.leftImage = OldFeedImage.more_circle,
      this.rightImage = OldFeedImage.search_circle});

  final String leftImage;
  final String rightImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints.expand(height: SizeUtil.getAxisY(152)),
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(
                height: SizeUtil.getAxisY(133)),
            decoration:
                BoxDecoration(gradient: LinearGradient(colors: [YELLOW, BLUE])),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: SizeUtil.getAxisY(30.0)),
              child: Text(
                'FEED',
                style: TextStyle(
                    color: TEXT_BLACK,
                    fontSize: SizeUtil.getAxisBoth(28),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAxisX(24.0)),
            alignment: AlignmentDirectional.bottomStart,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(leftImage,
                      width: SizeUtil.getAxisY(87),
                      height: SizeUtil.getAxisY(87)),
                  Image.asset(rightImage,
                      width: SizeUtil.getAxisY(87),
                      height: SizeUtil.getAxisY(87))
                ]),
          )
        ],
      ),
    );
  }
}
