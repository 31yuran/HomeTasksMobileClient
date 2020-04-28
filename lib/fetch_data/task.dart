import 'package:flutter/material.dart';
import 'package:home_task/fetch_data/user.dart';
import 'package:home_task/enums.dart' as enums;
import 'package:home_task/globals.dart' as globals;

class Task {
  int id;
  String giud;
  int userId;  
  String desc;
  DateTime timeToComplete;
  DateTime startOfExecution;
  DateTime endOfExecution;
  enums.TaskState state;
  double  cost;

  String get masterText => globals.currentUser?.name ?? "";
  String get descText => desc ?? "";
  DateTime get endOfExecutionProp => endOfExecution;
  set endOfExecutionProp(DateTime val) => endOfExecution = val.isBefore(DateTime.now()) ? DateTime.now().add(Duration(hours: 1)) : val;


  Task.init({this.userId, this.desc}){
  }
  Task._({this.id, this.userId, this.desc, this.endOfExecution, this.state});

  factory Task.fromJson(Map<String, dynamic> json) {
    return new Task._(
      id: json['id'],
      userId: json['userId'],
      desc: json['desc'],
      endOfExecution : DateTime.tryParse(json['endOfExecution']),
      state: enums.TaskState.values[json['state']],
    );
  }
  Map<String, dynamic> toJsonForPost(){
    return {
      'userId': this.userId,
      'desc':this.desc,
      'endOfExecution':this.endOfExecution.toIso8601String(),
    };
  }
  Map<String, dynamic> toJsonForPut(){
    return {
      'id': this.id,
      'userId': this.userId,
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