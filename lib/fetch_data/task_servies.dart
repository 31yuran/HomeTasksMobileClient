import 'package:eventhandler/eventhandler.dart';
import 'package:home_task/fetch_data/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:home_task/events.dart';
import 'package:home_task/globals.dart' as globals;
import 'package:home_task/enums.dart' as enums;
import 'package:home_task/fetch_data/user.dart';

class TaskServies {
  static String _ip = "http://192.168.56.1:3000";
  //static String _ip = "http://192.168.31.221:3000"; //for device in localhost
  static String _urlApi = _ip + "/api/hometasks";
  static String _urlSignal = _ip + "/myHub";
  static Map<String, String> _headers = {"Content-Type": "application/json"};
  HubConnection _hubConnection;

  static final TaskServies _singleton = TaskServies._internal();

  factory TaskServies() {
    return _singleton;
  }

  TaskServies._internal();

  void _createHubConnection() async {
    if (_hubConnection?.state == HubConnectionState.Disconnected) return;

    _hubConnection = HubConnectionBuilder()
        .withUrl(_urlSignal)
        .configureLogging(Logger("SignalR - hub"))
        .build();
    _hubConnection.onclose((error) => print("Connection Closed"));
    await _hubConnection.start();
    _hubConnection.on("addTaskHandle", _addTaskHandle);
    _hubConnection.on("changeTaskHandle", _changeTaskHandle);
    _hubConnection.on("removeTaskHandle", _removeTaskHandle);
  }

  void _addTaskHandle(List<Object> parameters) {
    EventHandler().send(AddTaskEvent());
    for (var i = 0; i < parameters.length; i++) {}
  }

  void _changeTaskHandle(List<Object> parameters) {
    EventHandler().send(ChangeTaskEvent());
    for (var i = 0; i < parameters.length; i++) {}
  }

  void _removeTaskHandle(List<Object> parameters) {
    EventHandler().send(RemoveTaskEvent());
    for (var i = 0; i < parameters.length; i++) {}
  }

  Future<http.Response> fetch() async {
    final response = await http.get(_urlApi);
    if (response.statusCode == 200 && _hubConnection == null) {
      _createHubConnection();
    }
    return response;
  }

  Future<http.Response> registerUser(
      String userName, String password, String slavePassword) async {
    Map body = {
      "name": userName,
      "password": password,
      "slavePassword": slavePassword
    };
    String jsonStr = jsonEncode(body);
    final response =
        await http.post(_urlApi + "/user", headers: _headers, body: jsonStr);
    //final response = await http.post(_urlApi + "/user" + "/$userName" + "/$password" +"/$slavePassword", headers: _headers);
    if (response.statusCode == 200) {
      globals.currentUser = new User.fromJson(json.decode(response.body));
      if (_hubConnection == null ||
          _hubConnection.state == HubConnectionState.Disconnected)
        _createHubConnection();
    }
    return response;
  }

  Future<http.Response> loginUser(String userName, String password) async {
    final response = await http.get(_urlApi + "/$userName" + "/$password");
    if (response.statusCode == 200) {
      globals.currentUser = new User.fromJson(json.decode(response.body));
      if (_hubConnection == null ||
          _hubConnection.state == HubConnectionState.Disconnected)
        _createHubConnection();
    }
    return response;
  }

  Future<http.Response> getCurrentUser() async {
    int userId = -1;
    if (globals.currentUser != null) {
      return new Future<http.Response>(() => new http.Response("", 200));
    } else {
      final idStr = await loadPref("userId");
      userId = idStr != null ? int.tryParse(idStr) ?? -1 : -1;
    }
    if (userId == -1)
      return new Future<http.Response>(() => new http.Response("", 204));

    final response = await http.get(_urlApi + "/$userId");
    if (response.statusCode == 200) {
      globals.currentUser = new User.fromJson(json.decode(response.body));
      if (_hubConnection == null ||
          _hubConnection.state == HubConnectionState.Disconnected)
        _createHubConnection();
    } else {
      globals.currentUser = null;
    }
    return response;
  }

  Future<http.Response> post(Task task) async {
    String jsonStr = jsonEncode(task.toJsonForPost());
    final response = await http.post(_urlApi, headers: _headers, body: jsonStr);
    if (response.statusCode == 200) {
      final newTask = new Task.fromJson(json.decode(response.body));
      task.id = newTask.id;
    }
    return response;
  }

  Future<http.Response> put(Task task) async {
    return await http.put(_urlApi,
        headers: _headers, body: jsonEncode(task.toJsonForPut()));
  }

  Future<http.Response> del(Task task) async {
    return await http.delete(_urlApi + "/${task.id}", headers: _headers);
  }

  Future<bool> savePref(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, val);
  }

  Future<String> loadPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
