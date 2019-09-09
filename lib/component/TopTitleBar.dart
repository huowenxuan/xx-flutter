import "package:flutter/material.dart";
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/SizeUtil.dart';
import 'package:flutter_ui_nice/const/images_const.dart';

class TopTitleBar extends StatelessWidget {
  TopTitleBar(
      {this.leftImage = OldFeedImage.more_circle,
      this.rightImage,
      this.title = 'FEED',
      this.leftPress,
      this.rightPress});

  final String leftImage;
  final String rightImage;
  final String title;
  final Function leftPress;
  final Function rightPress;

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
                title,
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
                  IconButton(
                    onPressed: leftPress != null
                        ? leftPress
                        : () {
                            Navigator.pop(context);
                          },
                    padding: EdgeInsets.all(0),
                    icon: Image.asset(
                      leftImage,
                      width: 40,
                    ),
                  ),
                  rightImage == null ? Container() : IconButton(
                    onPressed: rightPress,
                    icon: Image.asset(
                      rightImage,
                      width: 40,
                    ),
                    padding: EdgeInsets.all(0),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
