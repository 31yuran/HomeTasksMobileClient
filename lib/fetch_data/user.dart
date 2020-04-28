import 'dart:convert';
import 'dart:core';
import 'package:home_task/fetch_data/task.dart';
import 'package:home_task/enums.dart' as enums;

class User {
  int id;
  String name;
  String password;
  enums.UserRole role;
  List<Task> tasks;

  User._({this.id, this.name, this.password, this.role, this.tasks});
  User.init({this.id, this.name});

  factory User.fromJson(Map<String, dynamic> jsonData) => new User._(
      id: jsonData['id'],
      name: jsonData['name'],
      password: jsonData['password'],
      role: enums.UserRole.values[jsonData['role']],
      tasks:
          List<Task>.from(jsonData['tasks'].map((t) => new Task.fromJson(t))));
          
  Map<String, dynamic> toJsonForPost() {
    return {'name': this.name};
  }

  Map<String, dynamic> toJsonForPut() {
    return {'id': this.id, 'name': this.name};
  }
}
