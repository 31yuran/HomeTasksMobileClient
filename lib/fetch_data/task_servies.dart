import 'package:home_task/fetch_data/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:signalr_client/signalr_client.dart';

class  TaskServies{
  //static String url = "http://192.168.31.221:3000/api/hometasks/"; //for device in localhost
  static String url = "http://192.168.56.1:3000/api/hometasks";
  static Map<String, String> _headers = {"Content-Type" : "application/json"};

  static Future<http.Response> fetch() async{
    return await http.get(url);
  }

  static Future<http.Response> post(Task task) async {
    String jsonStr = jsonEncode(task.toJsonForPost());
    final response = await http.post(url, headers: _headers, body:  jsonStr);
    if(response.statusCode == 200){
      final newTask = new Task.fromJson(json.decode(response.body));
      task.id = newTask.id;
    }
    return response;
  }

  static Future<http.Response> put(Task task) async{
    return await http.put(url, headers: _headers, body: jsonEncode(task.toJsonForPut()));
  }

  static Future<http.Response> del(Task task) async{
    return await http.delete(url + "/${task.id}", headers: _headers);
  }
}