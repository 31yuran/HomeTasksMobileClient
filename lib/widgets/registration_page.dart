import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_task/fetch_data/user.dart';
import 'package:home_task/ui.dart' as ui;
import 'package:home_task/main.dart';
import 'package:home_task/globals.dart' as globals;

class RegistrationPage extends StatefulWidget {
  User _user;

  RegistrationPage({Key key}) : super(key: key);
  RegistrationPage.init(this._user);
  @override
  _RegistrationPageState createState() => _RegistrationPageState.init(_user);
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  User _user;
  ui.TextFieldValue _userName;
  ui.TextFieldValue _password;
  ui.TextFieldValue _slavePassword;

  _RegistrationPageState.init(this._user);
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
    _userName = new ui.TextFieldValue();
    _password = new ui.TextFieldValue();
    _slavePassword = new ui.TextFieldValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Регистрация'),
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
        'userName',
        'userName',
        _userName));

    widgets.add(ui.createTextField(
        (value) => setState(() {
              _password.value = value;
            }),
        'password',
        'password',
        _password));

    widgets.add(ui.createTextField(
        (value) => setState(() {
              _slavePassword.value = value;
            }),
        'slavePassword',
        'slavePassword',
        _slavePassword));

    widgets.add(new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('Зарегистрироватся'),
        onPressed: () {
          willWegister();
        }));
    return widgets;
  }

  void willWegister() async {
    final response = await globals.taskServies
        .registerUser(_userName.value, _password.value, _slavePassword.value);
    if (response.statusCode == 200)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    else if (response.statusCode == 409) showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text("User with $_userName alredy exsist!"),
      content: Text("Change user name."),
      actions: [
        okButton,
      ],
    );
  }
}
