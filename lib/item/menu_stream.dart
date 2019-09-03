import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ui_nice/item/Menu.dart';
import 'package:flutter_ui_nice/const/images_const.dart';

const SIGN_UP_PAGES = [
  "Sign up page 01",
  "Sign up page 02",
  "Sign up page 03",
  "Sign up page 04",
  "Sign up page 05",
  "Sign up page 06",
  "Sign up page 07",
  "Sign up page 08",
  "Sign up page 09",
  "Sign up page 10",
  "Sign up page 11",
];
const PROFILE_PAGES = [
  "Profile page 01",
  "Profile page 02",
];
const FEED_PAGES = [
  "Feed page 01",
  "Feed page 02",
  "Feed page 03",
  "Feed page 04",
  "Feed page 05",
  "Feed page 06",
  "Feed page 07",
  "Feed page 08",
  "Feed page 09",
];


const _MENU_STRINGS = [
  {
    'title': "Note",
    'icon': Icons.event_note,
    'image': MainImagePath.image_sign_up
  },
  {
    'title': "Vogue",
    'icon': Icons.photo_camera,
    'image': MainImagePath.image_walk_through
  },
  {
    'title': "Note",
    'icon': Icons.alternate_email,
    'image': MainImagePath.image_navigation
  },
  {
    'title': "Sign Up",
    'icon': Icons.airplay,
    'image': MainImagePath.image_sign_up,
    'items': SIGN_UP_PAGES
  },
  {
    'title': "Profile",
    'icon': Icons.question_answer,
    'image': MainImagePath.image_profile,
    'items': PROFILE_PAGES
  },
  {
    'title': "Feed",
    'icon': Icons.location_city,
    'image': MainImagePath.image_feed,
    'items': FEED_PAGES
  },
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
