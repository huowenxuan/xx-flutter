import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_ui_nice/const/color_const.dart';
import 'package:flutter_ui_nice/const/gradient_const.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter_ui_nice/const/size_const.dart';
import 'package:flutter_ui_nice/page/signup/widgets/signup_apbar.dart';
import 'package:flutter_ui_nice/util/Request.dart';
import 'package:toast/toast.dart';

class LogisticSubscribePage extends StatefulWidget {
  _SignPageElevenState createState() => _SignPageElevenState();
}

class _SignPageElevenState extends State<LogisticSubscribePage> {
  TextEditingController _numberController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  var _commonComs = []; // 常用物流公司
  String _currentCompany; // 当前物流，字符串

  var _emails = ['1078954008', '173141284'];
  String _currentEmail = '1078954008';

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    var response = await Request.get(Request.API + 'logistic/coms/common');
    setState(() {
      _commonComs = response['data'];
      _currentCompany = _commonComs[0]['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: SignupApbar(
        title: "Logistic Subscribe",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
              height: _media.height,
              width: _media.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    SignUpImagePath.SignUpPage_11_Bg,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 170,
                ),
                fieldColorBox(
                    SIGNUP_BACKGROUND,
                    "NUMBER",
                    TextField(
                      controller: _numberController,
                      onSubmitted: (text) async {
                        var response = await Request.get(
                            Request.API + 'logistic/autonumber/' + text);
                        setState(() {
                          var autoComs = response['data'];
                          if (autoComs != null && autoComs.length > 0) {
                            String auto = autoComs[0]['name'];
                            if (_commonComs.any((com) => com['name'] == auto))
                              _currentCompany = auto;
                          }
                        });
                        return true;
                      },
                      decoration: InputDecoration(
                          hintText: 'number',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: TEXT_NORMAL_SIZE, color: Colors.black)),
                    )),
                Wrap(children: <Widget>[
                  locationColorBox(SIGNUP_CARD_BACKGROUND, "COMPANY",
                      _currentCompany == null ? '' : _currentCompany,
                      _commonComs.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['name'],
                      child: Text(item['name']),
                    );
                  }), (String selected) {
                    setState(() {
                      _currentCompany = selected;
                    });
                  }),
                ]),
                Wrap(children: <Widget>[
                  locationColorBox(SIGNUP_BACKGROUND, "EMAIL", _currentEmail,
                      _emails.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }), (String selected) {
                    setState(() {
                      _currentEmail = selected;
                    });
                  }),
                ]),
                fieldColorBox(
                  SIGNUP_BACKGROUND,
                  "REMARK",
                  TextField(
                    controller: _remarkController,
                    decoration: InputDecoration(
                        hintText: 'remark',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: TEXT_NORMAL_SIZE, color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                nexButton("Subscribe"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget locationColorBox(
      Gradient gradient, String title, String current, items, onChanged) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30,
        bottom: 8,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 30,
              offset: Offset(1.0, 9.0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(fontSize: TEXT_SMALL_SIZE, color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  style: TextStyle(
                    fontSize: TEXT_NORMAL_SIZE,
                    color: Colors.black,
                  ),
                  isExpanded: true,
                  onChanged: onChanged,
                  items: items.toList(),
                  value: current,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldColorBox(Gradient gradient, String title, input) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30,
        bottom: 8,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 30,
              offset: Offset(1.0, 9.0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(fontSize: TEXT_SMALL_SIZE, color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Wrap(
                children: <Widget>[input],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nexButton(String text) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: 45,
        width: 120,
        decoration: BoxDecoration(
          gradient: SIGNUP_CIRCLE_BUTTON_BACKGROUND,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: YELLOW,
            fontWeight: FontWeight.w700,
            fontSize: TEXT_NORMAL_SIZE,
          ),
        ),
      ),
      onTap: () async {
        var data = {
          'number': _numberController.text,
          'remark': _remarkController.text,
          'company': _commonComs
              .firstWhere((item) => item['name'] == _currentCompany)['company'],
          'email': [_currentEmail + '@qq.com']
        };
        print(data);
        try {
          await Request.post(Request.API + 'logistic/subscribe', data);
          setState(() {
            _numberController.text = "";
            _remarkController.text = "";
          });
          Toast.show("OK!", context, gravity: Toast.BOTTOM);
        } catch(e) {
          Toast.show(e, context, gravity: Toast.BOTTOM, backgroundColor: RED);
        }
      },
    );
  }
}
