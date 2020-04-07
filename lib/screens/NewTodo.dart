import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Todo.dart';
import '../provider/todos.dart';

class NewTodo extends StatefulWidget {
  @override
  _NewTodoState createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  @override
  Widget build(BuildContext context) {
    final _textC = TextEditingController();

    _submitNewTodo() {
      if (_textC.text.isEmpty) {
        return;
      }

      Todo newTodo = Todo(
          text: _textC.text,
          addedOn: DateTime.now().toString().substring(0, 10),
          isFav: false);

      Provider.of<Todos>(context, listen: false)
          .addTodo(newTodo)
          .then((_) => Scaffold.of(context).hideCurrentSnackBar())
          .then((_) => {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Added New Todo!',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.lightGreen,
                  duration: Duration(seconds: 2),
                ))
              });
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[900],
      child: Center(
        child: Container(
          width: 500,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurpleAccent, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: TextField(
                  controller: _textC,
                  onSubmitted: (_) => _submitNewTodo,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      labelText: 'Add New Todo'),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.green[500],
                      onPressed: _submitNewTodo)),
            ],
          ),
        ),
      ),
    );
  }
}
