import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_task/globals.dart' as globals;
import 'package:home_task/ui.dart' as ui;

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState.init();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _UserInfoPageState.init();
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
          title: Text('Информация'),
        ),
        body: Form(
            key: _refreshIndicatorKey,
            child: new ListView(
              children: getFormWidget(),
            )));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    if (globals.currentUser != null) {
      formWidget.add(ui.createTextField(
          () => {}, globals.currentUser.name, "", new ui.TextFieldValue()));
      formWidget.add(DropdownButton<String>(
          hint: Text("Slaves"),
          items: [
            DropdownMenuItem(
              value: "1",
              child: Text(
                "First",
              ),
            ),
            DropdownMenuItem(
              value: "2",
              child: Text(
                "Second",
              ),
            ),
          ],
          onChanged: (value) {}));
    }
    return formWidget;
  }
}
