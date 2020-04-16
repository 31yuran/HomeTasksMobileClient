import 'package:flutter/material.dart';
import 'package:home_task/main.dart';

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
        selected: widget.selected == 'about',
        leading: Icon(Icons.info),
        title: Text('Про нас'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
      ),
      ListTile(
        selected: widget.selected == 'projects',
        leading: Icon(Icons.list),
        title: Text('Проекти'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ]));
  }
}
