///
/// Created by NieBin on 18-12-15
/// Github: https://github.com/nb312
/// Email: niebin312@gmail.com
///
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ui_nice/item/Menu.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter_ui_nice/const/page_str_const.dart';

const _MENU_STRINGS = [
  {
    'title': "Note",
    'items': SIGN_UP_PAGES,
    'icon': Icons.event_note,
    'image': MainImagePath.image_sign_up
  },

  {
    'title': "Vogue",
    'items': WALK_THROUGH_PAGES,
    'icon': Icons.photo_camera,
    'image': MainImagePath.image_walk_through
  },
  {
    'title': "Note",
    'items': NAVIGATION_PAGES,
    'icon': Icons.alternate_email,
    'image': MainImagePath.image_navigation
  }
];

const _MENU_COLORS = [
  0xff050505,
  0xffc8c4bd,
  0xffc7d8f4,
  0xff7f5741,
  0xff261d33,
  0xff2a8ccf,
  0xffe19b6b,
  0xffe19b6b,
  0xffddcec2,
  0xff261d33,
];

class MenuController {
  final controller = StreamController<List<Menu>>();

  Stream<List<Menu>> get menuItems => controller.stream;

  MenuController({List<Menu> menus}) {
    controller.add(menus ?? _defaultMenus());
  }

  List<Menu> _defaultMenus() {
    var list = List<Menu>();
    for (int i = 0; i < _MENU_STRINGS.length; i++) {
      list.add(Menu(
          title: _MENU_STRINGS[i % _MENU_STRINGS.length]['title'],
          icon: _MENU_STRINGS[i]['icon'],
          menuColor: Color(_MENU_COLORS[i]),
          image: _MENU_STRINGS[i]['image'],
          items: _MENU_STRINGS[i % _MENU_STRINGS.length]['items']
      ));
    }
    return list;
  }
}
