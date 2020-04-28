import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:home_task/fetch_data/task.dart';
import 'package:home_task/enums.dart' as enums;
import 'package:home_task/globals.dart' as globals;
import 'package:home_task/ui.dart' as ui;

class SlaveTaskPage extends StatefulWidget {
  Task _task;

  SlaveTaskPage({Key key}) : super(key: key);
  SlaveTaskPage.init(Task task) {
    _task = task ?? new Task.init();
  }

  @override
  _SlaveTaskPageState createState() => _SlaveTaskPageState.init(_task);
}

class _SlaveTaskPageState extends State<SlaveTaskPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Task _task;

  ui.TextFieldValue _master;
  ui.TextFieldValue _slave;
  ui.TextFieldValue _desc;
  ui.TextFieldValue _date;
  ui.TextFieldValue _time;

  _SlaveTaskPageState.init(Task task) {
    _task = task;
    _master = new ui.TextFieldValue();
    _slave = new ui.TextFieldValue();
    _desc = new ui.TextFieldValue();
    _date = new ui.TextFieldValue();
    _time = new ui.TextFieldValue();
  }
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
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
            )));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(ui.createTextField(
        (value) => setState(() {
              _master.value = value;
            }),
        _task.masterText,
        'enter master',
        _master));
    //formWidget.add(_createTestField( _task.slaveText,'enter slave', _slave));
    formWidget.add(ui.createTextField(
        (value) => setState(() {
              _desc.value = value;
            }),
        _task.descText,
        'enter desc',
        _desc));
    formWidget.add(ui.createDateTimeButton(
        () => setState(() {}), context, _time,
        isDate: false));
    formWidget.add(new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('Выполнено!'),
        onPressed: () {
          setState(() {
            if (_master?.value?.isNotEmpty ?? false)
              _task.userId = globals.currentUser.id;
            /*if (_slave?.value?.isNotEmpty ?? false)
              _task.slave.name = _slave.value;*/
            if (_desc?.value?.isNotEmpty ?? false) _task.desc = _desc.value;
            if (_time?.value?.isNotEmpty ?? false)
              _task.endOfExecution = ui.parseToDateTime(_time.value) ??
                  DateTime.now().add(Duration(minutes: 10));
            _task.state = enums.TaskState.assigned;
          });
          Navigator.pop(context, _task);
        }));
    return formWidget;
  }
}
