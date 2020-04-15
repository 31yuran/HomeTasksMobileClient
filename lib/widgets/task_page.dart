import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:home_task/fetch_data/task.dart';

class TaskPage extends StatefulWidget {
  Task _task;

  TaskPage({Key key}): super(key: key);
  TaskPage.init(Task task){
    _task = task ?? new Task.init();
    }

  @override
  _TaskPageState createState() => _TaskPageState.init(_task);
}
class _TaskPageState extends State<TaskPage>{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  Task _task;

  TextFieldValue _master;
  TextFieldValue _slave;
  TextFieldValue _desc;
  TextFieldValue _date;
  TextFieldValue _time;

  _TaskPageState.init(Task task){
    _task = task;
    _master = new TextFieldValue();
    _slave = new TextFieldValue();
    _desc = new TextFieldValue();
    _date = new TextFieldValue();
    _time = new TextFieldValue();
  }
@override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_){  _refreshIndicatorKey.currentState?.show(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задача'),
      ),
    body: Form(
        key: _refreshIndicatorKey,
        child: new ListView(
          children: getFormWidget(),
        )
      )
    );
  }

    List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add( _createTestField('enter master', _task.masterText, _master));
    formWidget.add( _createTestField('enter slave', _task.masterText, _slave));
    formWidget.add( _createTestField('enter desc', _task.desc, _desc));
    formWidget.add(_createDateTimeButton(_time, isDate : false) );
    formWidget.add(new RaisedButton(
      color: Colors.blue,
      textColor: Colors.white,
      child: new Text('OK'),
      onPressed: () { setState(() {
        if( _master?.value?.isNotEmpty ?? false) _task.master.name = _master.value;
        if(_slave?.value?.isNotEmpty ?? false) _task.slave.name = _slave.value;
        if(_desc?.value?.isNotEmpty ?? false) _task.desc = _desc.value;
        if(_time?.value?.isNotEmpty ?? false) 
          _task.endOfExecution = _parseToDateTime(_time.value) ?? DateTime.now().add(Duration(minutes: 10));
        _task.state = TaskState.assigned;
        });
        Navigator.pop(context, _task);
      }
    ));
    return formWidget;
  }

  DateTime _parseToDateTime(String str){
    String year, month, day, hours, minutes;
    var parts = str.split(' ').where((x)=>x.isNotEmpty).toList();
    if(parts.length == 2){
      var dateParts = parts[0].split('.');
      if(dateParts.length == 3){
        day = dateParts[0];
        month = dateParts[1];
        year = dateParts[2];
      }
      var timeParts = parts[1].split(':');
      if(timeParts.length == 2){
        hours = timeParts[0];
        minutes = timeParts[1];
      }
    }
    if(year == null || month == null || day == null || hours == null || minutes == null) return null;
    return new DateTime(int.parse(year), int.parse(month), int.parse(day), int.parse(hours), int.parse(minutes));
  }

  TextFormField _createTestField(String labelText, String hintText, TextFieldValue textValue ){
    return new TextFormField(
      decoration: InputDecoration(labelText: 'enter desc', hintText: hintText ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a name';
        }
      },
      onChanged: (value) { 
        setState(() { textValue.value = value; });
      },
    );
  }

  RaisedButton _createDateTimeButton(TextFieldValue textValue, {bool isDate}){
    return new RaisedButton(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0)),
      onPressed: (){
        var func = isDate ? DatePicker.showDatePicker : DatePicker.showDateTimePicker;
        func(
          context,
          theme: DatePickerTheme(
            containerHeight: 210.0,
          ),
          showTitleActions: true,
          onConfirm: (dateTime) {
            textValue.value = '${dateTime.day}.${dateTime.month}.${dateTime.year}''  ''${dateTime.hour}:${dateTime.minute}';
            setState(() {});
          },
          currentTime: DateTime.now(), locale: LocaleType.ru
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        size: 18.0,
                        color: Colors.teal,
                      ),
                      Text(
                        " ${textValue.value}",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              "  Change",
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
            ),
          ],
        ),
      ) 
    );
  }
}

class TextFieldValue{
  String value = "Not set";
}