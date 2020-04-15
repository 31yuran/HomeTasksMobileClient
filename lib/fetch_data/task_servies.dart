import 'package:eventhandler/eventhandler.dart';
import 'package:home_task/fetch_data/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:signalr_client/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:home_task/events.dart';

class  TaskServies{

  static String _ip = "http://192.168.56.1:3000";
  //static String _ip = "http://192.168.31.221:3000"; //for device in localhost
  static String _urlApi = _ip + "/api/hometasks";
  static String _urlSignal = _ip + "/myHub";
  static Map<String, String> _headers = {"Content-Type" : "application/json"};
  HubConnection _hubConnection;

  static final TaskServies _singleton = TaskServies._internal();

  factory TaskServies() {
    return _singleton;
  }

  TaskServies._internal();

  void _createHubConnection() async {
    _hubConnection = HubConnectionBuilder().withUrl(_urlSignal).configureLogging(Logger("SignalR - hub")).build();
    _hubConnection.onclose( (error) => print("Connection Closed"));
    await _hubConnection.start();
    _hubConnection.on("addTaskHandle", _addTaskHandle);
    _hubConnection.on("changeTaskHandle", _changeTaskHandle);
    _hubConnection.on("removeTaskHandle", _removeTaskHandle);
  }

  void _addTaskHandle(List<Object> parameters){
    EventHandler().send(AddTaskEvent());
    for(var i = 0; i < parameters.length; i++){

    }
  }
  void _changeTaskHandle(List<Object> parameters){
    EventHandler().send(ChangeTaskEvent());
    for(var i = 0; i < parameters.length; i++){

    }
  }
  void _removeTaskHandle(List<Object> parameters){
    EventHandler().send(RemoveTaskEvent());
    for(var i = 0; i < parameters.length; i++){

    }
  }

  Future<http.Response> fetch() async{
    final response = await http.get(_urlApi);
    if(response.statusCode == 200 && _hubConnection == null){
      _createHubConnection();
    }
    return  response;
  }

  Future<http.Response> post(Task task) async {
    String jsonStr = jsonEncode(task.toJsonForPost());
    final response = await http.post(_urlApi, headers: _headers, body:  jsonStr);
    if(response.statusCode == 200){
      final newTask = new Task.fromJson(json.decode(response.body));
      task.id = newTask.id;
    }
    return response;
  }

  Future<http.Response> put(Task task) async{
    return await http.put(_urlApi, headers: _headers, body: jsonEncode(task.toJsonForPut()));
  }

  Future<http.Response> del(Task task) async{
    return await http.delete(_urlApi + "/${task.id}", headers: _headers);
  }
}