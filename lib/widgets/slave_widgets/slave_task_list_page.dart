import 'package:flutter/material.dart';
import 'package:home_task/widgets/master_widgets/master_task_page.dart';
import 'package:home_task/widgets/count_down_timer.dart';
import 'package:flutter/scheduler.dart';
import 'dart:convert';
import 'package:eventhandler/eventhandler.dart';

import 'package:home_task/fetch_data/task.dart';
import 'package:home_task/widgets/drawer_main.dart';
import 'package:home_task/globals.dart' as globals;
import 'package:home_task/enums.dart' as enums;
import 'package:home_task/events.dart';
import 'package:home_task/widgets/slave_widgets/slave_task_page.dart';

class SlaveTaskListPage extends StatefulWidget {
  final String title;

  SlaveTaskListPage({Key key, this.title}) : super(key: key);

  @override
  _SlaveTaskListPageState createState() => _SlaveTaskListPageState();
}

class _SlaveTaskListPageState extends State<SlaveTaskListPage> {
  List<Task> _list = List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  void _onAddTaskEventHandler(AddTaskEvent event) {
    _fetchData();
  }

  void _onChangeTaskEventHandler(ChangeTaskEvent event) {
    _fetchData();
  }

  void _onRemoveTaskEventHandler(RemoveTaskEvent event) {
    _fetchData();
  }

  Future _fetchData() async {
    setState(() {
      _list = globals.currentUser?.tasks;
    });
  }

  void _editTask(Task task) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SlaveTaskPage.init(task)));
    if (result != null) {
      setState(() {
        task = result as Task;
        task.state = enums.TaskState.complete;
      });
      await globals.taskServies.put(task);
    }
  }

  @override
  void initState() {
    EventHandler().subscribe(_onAddTaskEventHandler);
    EventHandler().subscribe(_onChangeTaskEventHandler);
    EventHandler().subscribe(_onRemoveTaskEventHandler);

    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задачи'),
      ),
      drawer: DrawerMain(
        selected: "about",
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _fetchData,
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: _list[index].getColorByState(),
                borderRadius: new BorderRadius.circular(5.0),
              ),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.blue))),
                    child: Icon(Icons.book, color: Colors.white),
                  ),
                  title: Text(
                    _list[index].masterText,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(_list[index].descText,
                                style: TextStyle(color: Colors.black))),
                      ),
                      Expanded(
                          flex: 5,
                          child: Padding(
                              padding: EdgeInsets.only(left: 1.0),
                              child: CountDownTimer(
                                initialDate: _list[index].endOfExecutionProp ??
                                    DateTime.now().add(Duration(hours: 1)),
                                running: true,
                                height: 50,
                                width: 50,
                                backgroundColor: Colors.indigo,
                                timerTextStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                borderRadius: 100,
                                isRaised: true,
                                tracetime: (time) {
                                  if (DateTime.now()
                                      .isAfter(_list[index].endOfExecutionProp))
                                    setState(() {
                                      _list[index].state =
                                          enums.TaskState.nonComplete;
                                    });
                                },
                              )))
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Colors.black, size: 30.0),
                  onTap: () {
                    _editTask(_list[index]);
                  }),
            ));
          },
        ),
      ),
    );
  }
}
