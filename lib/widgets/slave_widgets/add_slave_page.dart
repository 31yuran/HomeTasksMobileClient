import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_task/fetch_data/user.dart';
import 'package:home_task/ui.dart' as ui;
import 'package:home_task/main.dart';
import 'package:home_task/globals.dart' as globals;
import 'package:home_task/widgets/registration_page.dart';
import 'package:home_task/widgets/user_info_page.dart';

class AddSlavePage extends StatefulWidget {
  User _user;

  AddSlavePage({Key key}) : super(key: key);
  AddSlavePage.init(this._user);
  @override
  _AddSlavePageState createState() => _AddSlavePageState.init(_user);
}

class _AddSlavePageState extends State<AddSlavePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  User _user;
  ui.TextFieldValue _userName;
  ui.TextFieldValue _sharedPassword;

  _AddSlavePageState.init(this._user);
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
    _userName = new ui.TextFieldValue();
    _sharedPassword = new ui.TextFieldValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add slave'),
        ),
        body: Form(
            key: _refreshIndicatorKey,
            child: new ListView(
              children: getFormWidgets(),
            )));
  }

  List<Widget> getFormWidgets() {
    var widgets = new List<Widget>();
    widgets.add(ui.createTextField(
        (value) => setState(() {
              _userName.value = value;
            }),
        'slaveName',
        'slaveName',
        _userName));
    widgets.add(ui.createTextField(
        (value) => setState(() {
              _sharedPassword.value = value;
            }),
        'sharedPassword',
        'sharedPassword',
        _sharedPassword));
    widgets.add(new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('Add'),
        onPressed: () {
          addSlave();
        }));
    return widgets;
  }

  void addSlave() async {
    final response = await globals.taskServies
        .addSlave(_userName.value, _sharedPassword.value);
    if (response.statusCode == 200)
      Navigator.pop(context);
    else if (response.statusCode == 204)
      showAlertDialog(context, "Slave not exist");
  }

  showAlertDialog(BuildContext context, String message) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Slave not found"),
      content: Text(message),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
