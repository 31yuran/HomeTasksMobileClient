import 'package:flutter/material.dart';
import 'package:home_task/fetch_data/user.dart';
import 'package:home_task/enums.dart' as enums;

class Task {
  int id;
  String giud;
  User user;  
  String desc;
  DateTime timeToComplete;
  DateTime startOfExecution;
  DateTime endOfExecution;
  enums.TaskState state;
  double  cost;

  String get masterText => user?.name ?? "";
  String get descText => desc ?? "";
  DateTime get endOfExecutionProp => endOfExecution;
  set endOfExecutionProp(DateTime val) => endOfExecution = val.isBefore(DateTime.now()) ? DateTime.now().add(Duration(hours: 1)) : val;


  Task.init({this.user, this.desc}){
    this.user = new User.init();
  }
  Task._({this.id, this.user, this.desc, this.endOfExecution, this.state});

  factory Task.fromJson(Map<String, dynamic> json) {
    return new Task._(
      id: json['id'],
      user: new User.fromJson(json['user']),
      desc: json['desc'],
      endOfExecution : DateTime.tryParse(json['endOfExecution']),
      state: enums.TaskState.values[json['state']],
    );
  }
  Map<String, dynamic> toJsonForPost(){
    return {
      'user': this.user.toJsonForPost(),
      'desc':this.desc,
      'endOfExecution':this.endOfExecution.toIso8601String(),
    };
  }
  Map<String, dynamic> toJsonForPut(){
    return {
      'id': this.id,
      'user': this.user.toJsonForPut(),
      'desc':this.desc,
      'endOfExecution':this.endOfExecution.toIso8601String(),
    };
  }
  Color getColorByState(){
    switch (this.state){
      case enums.TaskState.created: return Colors.blue;
      case enums.TaskState.assigned: return Colors.green;
      case enums.TaskState.complete: return Colors.yellowAccent;
      case enums.TaskState.nonComplete: return Colors.red;
      case enums.TaskState.verified: return Colors.green;
      case enums.TaskState.nonVerified: return Colors.grey;
    }
    return Colors.white;
  }
}