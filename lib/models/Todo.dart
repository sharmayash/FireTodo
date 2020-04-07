import 'package:flutter/foundation.dart';

class Todo {
  String id;
  String text;
  String user;
  String addedOn;
  bool isFav;

  Todo(
      {this.id,
      @required this.text,
      this.user,
      @required this.addedOn,
      @required this.isFav});
}
