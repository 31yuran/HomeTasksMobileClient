import 'package:flutter/material.dart';
import 'package:home_task/fetch_data/task_servies.dart';
import 'package:home_task/widgets/task_page.dart';
import 'package:home_task/widgets/count_down_timer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'dart:convert';
import 'package:signalr_client/signalr_client.dart';
import 'package:logging/logging.dart';

import 'package:home_task/fetch_data/task.dart';
import 'package:home_task/widgets/drawer_main.dart';

class TasksPage extends StatefulWidget {
  final String title;

  TasksPage({Key key, this.title}): super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> _list = List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  void _addTaskHandle(List<Object> parameters){
    for(var i = 0; i < parameters.length; i++){

    }
  }

Future _fetchData() async {    
    final response = await TaskServies.fetch();
    if (response.statusCode == 200) {
      setState(() {_list = (json.decode(response.body) as List).map((data) => new Task.fromJson(data)).toList();});

      final logger = Logger("SignalR - hub");
      final hubConnection = HubConnectionBuilder().withUrl("http://192.168.56.1:3000/myHub").configureLogging(logger).build();
      hubConnection.onclose( (error) => print("Connection Closed"));
      await hubConnection.start();
      hubConnection.on("addTaskHandle", _addTaskHandle);
    }
    else {return null;}
}

  void _addTask([Task task]) async {
    final result = await Navigator.push( context, MaterialPageRoute(builder: (context) => TaskPage.init(task)));
    if(result != null){
      setState(() {_list.add(result as Task);});
      await TaskServies.post(_list.last);
    }
  }

  void _editTask(Task task) async{
    final result = await Navigator.push( context, MaterialPageRoute(builder: (context) => TaskPage.init(task)));
    if(result != null){
      setState(() { task = result as Task;});
      await TaskServies.put(task);
    }
  }

  void _deleteTask(Task task) async{
    await TaskServies.del(task);
  }

  void deleteItem (index){ 
    _deleteTask(_list[index]);
    setState((){ _list.removeAt(index); });
  }

  void undoDeletion (index, item) async{    
    await TaskServies.post(item);
    setState((){ _list.insert(index, item); }); 
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_){  _refreshIndicatorKey.currentState?.show(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задачи'),
      ),
      drawer: DrawerMain(selected: "about",),
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
                child:Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: _list[index].getColorByState(),
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(right: new BorderSide(width: 1.0, color: Colors.blue))),
                    child: Icon(Icons.book, color: Colors.white),
                  ),
                  title: Text(
                    _list[index].masterText,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(_list[index].descText, style: TextStyle(color: Colors.black))),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: CountDownTimer(
                            initialDate: _list[index].endOfExecutionProp ?? DateTime.now().add(Duration(hours: 1)),
                            running: true,
                            height: 50,
                            width: 50,
                            backgroundColor: Colors.indigo,
                            timerTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                            borderRadius: 100,
                            isRaised: true,
                            tracetime: (time) {
                              if( DateTime.now().isAfter(_list[index].endOfExecutionProp))
                                setState(() {
                                  _list[index].state = TaskState.nonComplete;
                                });
                            },
                          )
                        )
                      )
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
                  onTap: () {
                    _editTask(_list[index]);
                  }
                ),
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
                        })
                  ));
                }
              )
            );
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
      padding: isRightSwipe ? EdgeInsets.only(left: 20.0) : EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}