import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_ui_nice/component/TopTitleBar.dart';
import 'package:flutter_ui_nice/util/GradientUtil.dart';
import 'package:flutter_ui_nice/const/images_const.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_nice/util/Request.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class NoteDetailPage extends StatefulWidget {
  final data;
  final isEditMode;
  final onSuccess;

  // 类的构造器，用来接收传递的值
  NoteDetailPage({Key key, this.data, this.isEditMode, this.onSuccess})
      : super(key: key);

  @override
  NoteDetailPageState createState() => NoteDetailPageState();
}

class NoteDetailPageState extends State<NoteDetailPage> {
  TextEditingController _inputController = TextEditingController();
  bool _isEditMode;
  var _data;

  bool _hadStart = false;
  DateTime _startDate = null;
  DateTime _endDate = null;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    var data = widget.data;
    var isEditMode = widget.isEditMode;
    setState(() {
      _isEditMode = true;
      if (isEditMode != null) {
        _isEditMode = isEditMode;
      }

      if (data == null) {
        data = {'text': ''};
      }
      _data = data;
      _inputController.text = data['text'];

      if (data['start'] != null) {
        DateTime start = DateTime.parse(data['start']);
        _hadStart = true;
        _startDate = start;
        _startTime = start != null ? TimeOfDay.fromDateTime(start) : null;
      }

      DateTime end = DateTime.now();
      if (data['end'] != null)
        end = DateTime.parse(data['end']);
      _endDate = end;
      _endTime = TimeOfDay.fromDateTime(end);
    });
  }

  _getInput() {
    return _inputController.text;
  }

  _formatDateTime(isStart) {
    DateTime date;
    TimeOfDay time;
    if (isStart) {
      date = _startDate;
      time = _startTime;
    } else {
      date = _endDate;
      time = _endTime;
    }
    if (date == null || time == null) return {};

    String dateStr = DateFormat('y/M/d').format(date);
    String timeStr = time.hour.toString() + ':' + time.minute.toString();
    String str = dateStr + ' ' + timeStr;
    DateTime datetime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    var data = {
      'str': str,
      'dateStr': dateStr,
      'timeStr': timeStr,
      'datetime': datetime,
      'timestamp': datetime.millisecondsSinceEpoch
    };
    return data;
  }

  Future _selectDate(isStart, isDate) async {
    if (isDate) {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: isStart ? _startDate : _endDate,
          firstDate: new DateTime(2019),
          lastDate: new DateTime(2030));
      if (picked != null) {
        setState(() {
          if (isStart) {
            _startDate = picked;
          } else {
            _endDate = picked;
          }
        });
      }
    } else {
      TimeOfDay picked = await showTimePicker(
          context: context, initialTime: isStart ? _startTime : _endTime);
      if (picked != null) {
        setState(() {
          if (isStart) {
            _startTime = picked;
          } else {
            _endTime = picked;
          }
        });
      }
    }
  }

  Widget _pickerInput(isStart, isDate) {
    return Container(
      width: 160,
      child: TextField(
        keyboardType: TextInputType.datetime,
        onTap: () {
          _selectDate(isStart, isDate);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText:
              _formatDateTime(isStart)[isDate ? 'dateStr' : 'timeStr'] != null
                  ? _formatDateTime(isStart)[isDate ? 'dateStr' : 'timeStr']
                  : '',
          hintStyle: TextStyle(
            letterSpacing: 2.0,
            color: Color(0xff353535),
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _formTextField(String text, showPicker, rightChild) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Row(
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black26,
                ),
              ),
              rightChild != null ? rightChild : Container()
            ],
          ),
        ),
        showPicker
            ? Row(children: <Widget>[
                _pickerInput(text == 'START', true),
                _pickerInput(text == 'START', false),
              ])
            : Container(),
      ],
    );
  }

  Widget _reviewMode() {
    return Column(
      children: <Widget>[
        TopTitleBar(
          title: "REVIEW",
          leftImage: OldFeedImage.more_circle,
          rightImage: OldFeedImage.search_circle, // copy
          rightPress: () {
            Clipboard.setData(ClipboardData(
                text: _getInput() != null ? _getInput() : _data['text']));
            Toast.show("Copy Done!", context,
                gravity: Toast.BOTTOM, backgroundColor: Color(0xFF34323D));
          },
        ),
        Expanded(
          child:
              Markdown(data: _getInput() != null ? _getInput() : _data['text']),
        )
      ],
    );
  }

  Widget _editMode() {
    return Column(
      children: <Widget>[
        TopTitleBar(
          title: "EDIT",
          leftImage: OldFeedImage.more_circle,
          rightImage: OldFeedImage.feed_add,
          rightPress: () async {
            String dialogText = '';
            try {
              if (_endDate == null) return;
              String text = _getInput();
              if (text == null || text.isEmpty) return;
              var postData = {
                'user_id': '1',
                'text': text,
                'start': _hadStart ? _formatDateTime(true)['datetime'].toString() : null,
                'end': _formatDateTime(false)['datetime'].toString()
              };
              if (_data['_id'] != null) {
                await Request.put(
                    Request.API + 'note/' + _data['_id'], postData);
              } else {
                await Request.post(Request.API + 'note', postData);
              }
              if (widget.onSuccess != null) widget.onSuccess();
              dialogText = '保存成功!';
              Navigator.pop(context);
            } catch (e) {
              dialogText = e.toString();
            }

            Toast.show(dialogText, context,
                gravity: Toast.BOTTOM, backgroundColor: Color(0xFF34323D));
          },
        ),
        Container(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            children: <Widget>[
              _formTextField(
                  'START',
                  _hadStart,
                  Switch(
                    onChanged: (newValue) {
                      setState(() {
                        _hadStart = newValue;
                        if (_startDate == null) {
                          _startDate = DateTime.now();
                          _startTime = TimeOfDay.now();
                        }
                      });
                    },
                    value: _hadStart,
//                    activeColor: Colors.red,
                    activeTrackColor: Colors.cyan,
//                    inactiveThumbColor: Colors.green,
//                    inactiveTrackColor: Colors.blue,
                  )),
              _formTextField(
                  'END',
                  true,
                  IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.update),
                    onPressed: () {
                      setState(() {
                        _endDate = DateTime.now();
                        _endTime = TimeOfDay.now();
                      });
                    },
                  ))
//                  ButtonTheme(
//                    minWidth: 0.0,
//                    height: 20.0,
//                    child: RaisedButton(
//                      padding: EdgeInsets.all(0),
//                      onPressed: () {},
//                      child: Text("test"),
//                    ),
//                  ))
            ],
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            maxLines: 300,
            controller: _inputController,
            autocorrect: false,
          ),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.transform),
          onPressed: () {
            setState(() {
              _isEditMode = !_isEditMode;
            });
          }),
      body: Container(
          decoration: BoxDecoration(gradient: GradientUtil.yellowGreen()),
          child: Container(child: _isEditMode ? _editMode() : _reviewMode())),
    );
  }
}
