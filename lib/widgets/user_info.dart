import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UserInfoPage extends StatefulWidget {

  UserInfoPage({Key key}) : super(key: key);
  UserInfoPage.init() {
  }

  @override
  _UserInfoPageState createState() => _UserInfoPageState.init();
}
class _UserInfoPageState extends State<UserInfoPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  _UserInfoPageState.init() {
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
    return formWidget;
  }
}
class TextFieldValue {
  String value = "Not set";
}
