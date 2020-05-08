import 'dart:convert';
import 'dart:core';
import 'package:home_task/fetch_data/task.dart';
import 'package:home_task/enums.dart' as enums;
import 'package:home_task/fetch_data/related_user.dart';

class User {
  int id;
  String name;
  String password;
  enums.UserRole role;
  List<Task> tasks;
  List<RelatedUser> masters;
  List<RelatedUser> slaves;

  User._(
      {this.id, this.name, this.password, this.role, this.tasks, this.slaves});
  User.init({this.id, this.name});

  factory User.fromJson(Map<String, dynamic> jsonData) => new User._(
      id: jsonData['id'],
      name: jsonData['name'],
      password: jsonData['password'],
      tasks: jsonData['tasks'] == null
          ? new List<Task>()
          : List<Task>.from(jsonData['tasks'].map((t) => new Task.fromJson(t))),
      slaves: jsonData['slaves'] == null
          ? new List<RelatedUser>()
          : List<RelatedUser>.from(
              jsonData['slaves'].map((t) => new RelatedUser.fromJson(t))));

  Map<String, dynamic> toJsonForPost() {
    return {'name': this.name};
  }

  Map<String, dynamic> toJsonForPut() {
    return {'id': this.id, 'name': this.name};
  }
}
