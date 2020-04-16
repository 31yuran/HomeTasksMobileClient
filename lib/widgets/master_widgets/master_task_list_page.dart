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

class MasterTaskListPage extends StatefulWidget {
  final String title;

  MasterTaskListPage({Key key, this.title}) : super(key: key);

  @override
  _MasterTaskListPageState createState() => _MasterTaskListPageState();
}

class _MasterTaskListPageState extends State<MasterTaskListPage> {
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
    final response = await globals.taskServies.fetch();
    if (response.statusCode == 200) {
      setState(() {
        _list = (json.decode(response.body) as List)
            .map((data) => new Task.fromJson(data))
            .toList();
      });
    } else {
      return null;
    }
  }

  void _addTask([Task task]) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => MasterTaskPage.init(task)));
    if (result != null) {
      setState(() {
        _list.add(result as Task);
      });
      await globals.taskServies.post(_list.last);
    }
  }

  void _editTask(Task task) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => MasterTaskPage.init(task)));
    if (result != null) {
      setState(() {
        task = result as Task;
      });
      await globals.taskServies.put(task);
    }
  }

  void _deleteTask(Task task) async {
    await globals.taskServies.del(task);
  }

  void deleteItem(index) {
    _deleteTask(_list[index]);
    setState(() {
      _list.removeAt(index);
    });
  }

  void undoDeletion(index, item) async {
    await globals.taskServies.post(item);
    setState(() {
      _list.insert(index, item);
    });
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
                child: Dismissible(
                    key: ObjectKey(_list[index]),
                    background: stackBehindDismiss(true),
                    secondaryBackground: stackBehindDismiss(false),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: _list[index].getColorByState(),
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 30.0),
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
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
                                        initialDate:
                                            _list[index].endOfExecutionProp ??
                                                DateTime.now()
                                                    .add(Duration(hours: 1)),
                                        running: true,
                                        height: 50,
                                        width: 50,
                                        backgroundColor: Colors.indigo,
                                        timerTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        borderRadius: 100,
                                        isRaised: true,
                                        tracetime: (time) {
                                          if (DateTime.now().isAfter(
                                              _list[index].endOfExecutionProp))
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
                    ),
                    onDismissed: (direction) {
                      var item = _list.elementAt(index);
                      deleteItem(index);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Item deleted"),
                          action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                //To undo deletion
                                undoDeletion(index, item);
                              })));
                    }));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget stackBehindDismiss(bool isRightSwipe) {
    return Container(
      alignment: isRightSwipe ? Alignment.centerLeft : Alignment.centerRight,
      padding: isRightSwipe
          ? EdgeInsets.only(left: 20.0)
          : EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
