import 'package:flutter/material.dart';

import 'package:home_task/globals.dart' as globals;
import 'package:home_task/enums.dart' as enums;
import 'package:home_task/widgets/master_widgets/master_task_list_page.dart';
import 'package:home_task/widgets/slave_widgets/slave_task_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    globals.userRole = enums.UserRole.master;
    return Scaffold(
      body: Center(
        child: globals.userRole == enums.UserRole.master
            ? MasterTaskListPage(key: ValueKey("main"), title: "main")
            : SlaveTaskListPage(key: ValueKey("main"), title: "main"),
      ),
    );
  }
}
