import 'package:flutter/material.dart';
import 'package:flutter_ui_nice/page/page_const.dart';
import 'package:flutter/services.dart';

import 'const/string_const.dart';
import 'const/color_const.dart';
import "page/page_const.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: StringConst.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: BLUE_DEEP,
        accentColor: YELLOW,
        fontFamily: "Montserrat",
      ),
      home: HomePage(),
      routes: {
        'NOTE_LIST': (context) => NoteListPage(),
        'VOGUE_LIST': (context) => VogueListPage(),

        //PROFILE pages
        'PROFILE_PAGES[0]': (context) => ProfilePageOne(),
        'PROFILE_PAGES[1]': (context) => ProfilePageTwo(),

        'SIGN_UP_PAGES[0]': (context) => SignPageOne(),
        'SIGN_UP_PAGES[1]': (context) => SignPageTwo(),
        'SIGN_UP_PAGES[2]': (context) => SignPageThree(),
        'SIGN_UP_PAGES[3]': (context) => SignPageFour(),
        'SIGN_UP_PAGES[4]': (context) => SignPageFive(),
        'SIGN_UP_PAGES[5]': (context) => SignPageSix(),
        'SIGN_UP_PAGES[6]': (context) => SignPageSeven(),
        'SIGN_UP_PAGES[7]': (context) => SignPageEight(),
        'SIGN_UP_PAGES[8]': (context) => SignPageNine(),
        'SIGN_UP_PAGES[9]': (context) => SignPageTeen(),
        'SIGN_UP_PAGES[10]': (context) => SignPageEleven(),

        ///FEED group page
        'FEED_PAGES[0]': (context) => FeedPageOne(),
        'FEED_PAGES[1]': (context) => FeedPageTwo(),
        'FEED_PAGES[2]': (context) => FeedThreePage(),
        'FEED_PAGES[3]': (context) => FeedPageFour(),
        'FEED_PAGES[4]': (context) => FeedFivePage(),
        'FEED_PAGES[5]': (context) => FeedPageTen(),
        'FEED_PAGES[6]': (context) => FeedPageEleven(),
        // VOGUE LIST 模仿
        'FEED_PAGES[7]': (context) => FeedPageTwelve(),
        // Note模仿
        'FEED_PAGES[8]': (context) => FeedPageThirteen(),
      },
      onUnknownRoute: (setting) =>
          MaterialPageRoute(builder: (context) => EmptyPage()),
    );
  }
}
