import 'dart:core';

class RelatedUser {
  int id;
  String name;
  String sharedPassword;

  RelatedUser._({this.id, this.name, this.sharedPassword});
  factory RelatedUser.fromJson(Map<String, dynamic> jsonData) =>
      new RelatedUser._(
          id: jsonData['id'], name: jsonData['name'], sharedPassword: jsonData['sharedPassword']);
}
