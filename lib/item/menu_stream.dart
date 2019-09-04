import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ui_nice/item/Menu.dart';
import 'package:flutter_ui_nice/const/images_const.dart';

const SIGN_UP_PAGES = [
  'SIGN_UP_PAGES[0]',
  'SIGN_UP_PAGES[2]',
  'SIGN_UP_PAGES[3]',
  'SIGN_UP_PAGES[4]',
  'SIGN_UP_PAGES[5]',
  'SIGN_UP_PAGES[6]',
  'SIGN_UP_PAGES[7]',
  'SIGN_UP_PAGES[8]',
  'SIGN_UP_PAGES[9]',
  'SIGN_UP_PAGES[10]'
];
const PROFILE_PAGES = [
  'PROFILE_PAGES[0]',
  'PROFILE_PAGES[1]'
];
const FEED_PAGES = [
  'FEED_PAGES[0]',
  'FEED_PAGES[1]',
  'FEED_PAGES[2]',
  'FEED_PAGES[3]',
  'FEED_PAGES[4]',
  'FEED_PAGES[5]',
  'FEED_PAGES[6]',
  'FEED_PAGES[7]',
  'FEED_PAGES[8]',
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
