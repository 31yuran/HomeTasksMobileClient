import 'package:flutter/material.dart';
import 'package:home_task/main.dart';
import 'package:home_task/globals.dart' as globals;
import 'package:home_task/enums.dart' as enums;
import 'package:home_task/widgets/login_page.dart';
import 'package:home_task/widgets/registration_page.dart';
import 'package:home_task/widgets/user_info_page.dart';

class DrawerMain extends StatefulWidget {
  DrawerMain({Key key, this.selected}) : super(key: key);

  final String selected;

  @override
  DrawerMainState createState() {
    return DrawerMainState();
  }
}

class DrawerMainState extends State<DrawerMain> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        child: Text(
          'Flutter demo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        selected: widget.selected == 'masterTasks',
        leading: Icon(Icons.list),
        title: Text('Назаначенные'),
        onTap: () {
          globals.currentUser.role = enums.UserRole.master;
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
      ),
      ListTile(
        selected: widget.selected == 'slaveTasks',
        leading: Icon(Icons.list),
        title: Text('Полученные'),
        onTap: () {
          globals.currentUser.role = enums.UserRole.slave;
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
      ),
      ListTile(
        selected: widget.selected == 'info',
        leading: Icon(Icons.info),
        title: Text('Информация'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoPage()));
        },
      ),
      ListTile(
        selected: widget.selected == 'login',
        leading: Icon(Icons.nature_people),
        title: Text('Войти'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
      ),
      ListTile(
        selected: widget.selected == 'registration',
        leading: Icon(Icons.nature_people),
        title: Text('Регистрация'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
        },
      ),
    ]));
  }
}
