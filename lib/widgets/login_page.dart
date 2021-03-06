import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_task/fetch_data/user.dart';
import 'package:home_task/ui.dart' as ui;
import 'package:home_task/main.dart';
import 'package:home_task/globals.dart' as globals;
import 'package:home_task/widgets/registration_page.dart';

class LoginPage extends StatefulWidget {
  User _user;

  LoginPage({Key key}) : super(key: key);
  LoginPage.init(this._user);
  @override
  _LoginPageState createState() => _LoginPageState.init(_user);
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  User _user;
  ui.TextFieldValue _userName;
  ui.TextFieldValue _password;

  _LoginPageState.init(this._user);
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
    _userName = new ui.TextFieldValue();
    _password = new ui.TextFieldValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Войти'),
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
    widgets.add(new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('Войти'),
        onPressed: () {
          login();
        }));
    return widgets;
  }

  void login() async {
    final response =
        await globals.taskServies.loginUser(_userName.value, _password.value);
    if (response.statusCode == 200)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    else if(response.statusCode == 204)
      showAlertDialog(context,response.body);
  }

  showAlertDialog(BuildContext context, String message) {
    Widget cancelButton = FlatButton(
      child: Text("Повторить"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Регистрация"),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RegistrationPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("User not found"),
      content: Text(message +". " "Would you like to repeat or registration ?"),
      actions: [
        cancelButton,
        continueButton,
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
