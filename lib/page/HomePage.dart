import "package:flutter/material.dart";
import 'package:flutter_ui_nice/menu/menu_stream.dart';
import 'package:flutter_ui_nice/menu/Menu.dart';
import 'package:flutter_ui_nice/const/string_const.dart';
import 'package:flutter_ui_nice/view/AboutMeTitle.dart';
import 'package:flutter_ui_nice/const/size_const.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/util/SizeUtil.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_ui_nice/page/page_const.dart';

class HomePage extends StatelessWidget {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  final LocalStorage storage = new LocalStorage('xx');

  saveX() async {
    await storage.setItem('x', true);
  }

  Widget _menuItem(context, item) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        margin: EdgeInsets.only(bottom: 1.0),
        decoration: BoxDecoration(gradient: GradientUtil.greenPurple()),
        constraints: BoxConstraints.expand(height: 60.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                item,
                style: TextStyle(
                    color: TEXT_BLACK_LIGHT,
                    fontSize: TEXT_NORMAL_SIZE,
                    fontWeight: FontWeight.w700),
              ),
            ]),
      ),
      onTap: () {
//        Navigator.pop(context);
        Navigator.pushNamed(context, "$item");
      },
    );
  }

  Widget _menuList(Menu menu) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _menuItem(context, menu.items[index]);
      },
      itemCount: menu.items.length,
    );
  }

  Widget _menuHeader() {
    return Ink(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        decoration: BoxDecoration(
          gradient: GradientUtil.yellowGreen(),
        ),
        constraints: BoxConstraints.expand(height: 80.0),
        child: Center(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage(MainImagePath.image_header),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                StringConst.CREATE_BY,
                style: TextStyle(
                    color: TEXT_BLACK_LIGHT, fontSize: TEXT_NORMAL_SIZE),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clickMenu(context, Menu menu) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Material(
        color: GREEN,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _menuHeader(),
            Expanded(
              child: Container(
                child: _menuList(menu),
              ),
            ),
            AboutMeTitle(),
          ],
        ),
      ),
    );
  }

  LinearGradient _itemGradient(index) {
    var gradient = GradientUtil.red(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        opacity: 0.7);
    switch (index % 4) {
      case 0:
        gradient = GradientUtil.red(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            opacity: 0.7);
        break;
      case 1:
        gradient = GradientUtil.greenPurple(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            opacity: 0.7);
        break;
      case 2:
        gradient = GradientUtil.greenRed(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            opacity: 0.7);
        break;
      case 3:
        gradient = GradientUtil.yellowBlue(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            opacity: 0.7);
        break;
    }
    return gradient;
  }

  Widget _gridItem(context, Menu menu, index) => InkWell(
        onTap: () {
          switch (menu.title) {
            case 'Note':
              Navigator.pushNamed(context, "NOTE_LIST");
              break;
            case 'Vogue':
              Navigator.pushNamed(context, "VOGUE_LIST");
              break;
            case 'Logistic':
              Navigator.pushNamed(context, 'LOGISTIC_SUBSCRIBE');
              break;
            case 'X':
              var x = storage.getItem('x');
              if (x == true) Navigator.pushNamed(context, 'X');
              break;
            default:
              _clickMenu(context, menu);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              menu.image,
              fit: BoxFit.cover,
            ),
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(gradient: _itemGradient(index)),
            ),
            Container(
              constraints: BoxConstraints.expand(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      menu.icon,
                      color: TEXT_BLACK_LIGHT,
                      size: 40.0,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      menu.title,
                      style: TextStyle(
                          color: TEXT_BLACK_LIGHT,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _gridView(BuildContext context, List<Menu> list) => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 0.8,
            crossAxisCount: 2),
        delegate: SliverChildBuilderDelegate((context, index) {
          var menu = list[index];
          return _gridItem(context, menu, index);
        }, childCount: list.length),
      );

  Widget _streamBuild(context) {
    var controller = MenuController();
    return StreamBuilder(
      builder: (context, shot) {
        return shot.hasData
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    YELLOW,
                    BLUE,
                  ]),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    _gridView(context, shot.data),
                  ],
                ))
            : Center(
                child: CircularProgressIndicator(),
              );
      },
      stream: controller.menuItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;
    // saveX();
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Scaffold(
        key: _scaffoldState,
        body: _streamBuild(context),
      ),
    );
  }
}
