import 'package:flutter/material.dart';
import 'package:home_task/fetch_data/master.dart';
import 'package:home_task/fetch_data/slave.dart';
import 'package:home_task/enums.dart' as enums;

class Task {
  int id;
  String giud;
  Master master;
  Slave slave;
  String desc;
  DateTime timeToComplete;
  DateTime startOfExecution;
  DateTime endOfExecution;
  enums.TaskState state;
  double  cost;

  String get masterText => master?.name ?? "";
  String get slaveText => slave?.name ?? "";
  String get descText => desc ?? "";
  DateTime get endOfExecutionProp => endOfExecution;
  set endOfExecutionProp(DateTime val) => endOfExecution = val.isBefore(DateTime.now()) ? DateTime.now().add(Duration(hours: 1)) : val;


  Task.init({this.slave, this.desc}){
    this.master = new Master.init();
    this.slave = new Slave.init();
  }
  Task._({this.id, this.master, this.slave, this.desc, this.endOfExecution, this.state});

  factory Task.fromJson(Map<String, dynamic> json) {
    return new Task._(
      id: json['id'],
      master: new Master.fromJson(json['master']),
      slave: new Slave.fromJson(json['slave']),
      //master: json['master'],
      //slave: json['slave'],
      desc: json['desc'],
      endOfExecution : DateTime.tryParse(json['endOfExecution']),
      state: enums.TaskState.values[json['state']],
    );
  }
  Map<String, dynamic> toJsonForPost(){
    return {
      'master': this.master.toJsonForPost(),
      'slave': this.slave.toJsonForPost(),
      'desc':this.desc,
      'endOfExecution':this.endOfExecution.toIso8601String(),
    };
  }
  Map<String, dynamic> toJsonForPut(){
    return {
      'id': this.id,
      'master': this.master.toJsonForPut(),
      'slave': this.slave.toJsonForPut(),
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