import 'package:home_task/fetch_data/task.dart';
import 'package:home_task/enums.dart' as enums;

class User{
  int id;
  String name;
  String password;
  enums.UserRole role;
  List<Task> tasks;

  User._({this.id, this.name, this.password, this.role, this.tasks});
  User.init({this.id, this.name});
  
  factory User.fromJson(Map<String, dynamic> json){
    return new User._(
      id :json['id'],
      name : json['name'],
      password : json['password'],
      role: enums.UserRole.values[json['role']],
      tasks: json['tasks'].map((data) => new Task.fromJson(data)).toList()
    );
  }
  Map<String, dynamic> toJsonForPost(){
    return {
      'name':this.name
    };
  }
  Map<String, dynamic> toJsonForPut(){
    return {
      'id': this.id,
      'name' : this.name
    };
  }
}