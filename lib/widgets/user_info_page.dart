import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_task/fetch_data/related_user.dart';
import 'package:home_task/globals.dart' as globals;
import 'package:home_task/ui.dart' as ui;
import 'package:home_task/widgets/slave_widgets/add_slave_page.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState.init();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<RelatedUser> _slaves;

  _UserInfoPageState.init();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> _fetchData() async {
    setState(() {
      _slaves = globals.currentUser?.slaves ?? new List<RelatedUser>();
    });
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    if (globals.currentUser != null) {
      formWidget.add(ui.createTextField(
          () => {}, globals.currentUser.name, "", new ui.TextFieldValue()));

      _slaves = globals.currentUser?.slaves ?? new List<RelatedUser>();
      var ddItems = ui.createSlavesDropDownItems(_slaves);
      ddItems.add(new DropdownMenuItem(child: Text("Add"), value: "Add"));
      formWidget.add(DropdownButton<String>(
        hint: Text("Slaves"),
        items: ddItems,
        onChanged: (String value) {
          if (value == "Add") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddSlavePage()));
          }
        },
      ));
    }
    return formWidget;
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
}
