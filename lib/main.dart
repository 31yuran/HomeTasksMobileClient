import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

import 'package:home_task/globals.dart' as globals;
import 'package:home_task/enums.dart' as enums;
import 'package:home_task/widgets/master_widgets/master_task_list_page.dart';
import 'package:home_task/widgets/slave_widgets/slave_task_list_page.dart';
import 'package:home_task/fetch_data/user.dart';
import 'package:home_task/widgets/login_page.dart';

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
  void initState() {
    super.initState();
    //globals.taskServies.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: globals.taskServies.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            switch (snapshot.data.statusCode) {
              case 200:
                return Scaffold(
                  body: Center(
                    child: globals.currentUser == null
                        ? LoginPage.init(null)
                        : globals.currentUser.role == enums.UserRole.master
                            ? MasterTaskListPage(
                                key: ValueKey("main"), title: "main")
                            : SlaveTaskListPage(
                                key: ValueKey("main"), title: "main"),
                  ),
                );
              case 204:
                return Scaffold(
                  body: Center(child: LoginPage.init(null)),
                );
            }
            return Center(child: new Text('${snapshot.data.statusCode}'));
          }
        }
      },
    );
  }
}
