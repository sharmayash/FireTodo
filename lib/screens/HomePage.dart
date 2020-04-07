import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Todo.dart';
import '../provider/todos.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _editTextC = TextEditingController();
    List<Todo> todoItems = Provider.of<Todos>(context).todoList;

    updatingTodos(String id, String text) {
      if (text.isEmpty) {
        return;
      }
      Provider.of<Todos>(context, listen: false)
          .updateTodo(id, text)
          .then((_) => Navigator.of(context).popUntil(ModalRoute.withName('/')))
          .then((_) => Scaffold.of(context).hideCurrentSnackBar())
          .then((_) => {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Updated your Todo!',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.lightGreen,
                  duration: Duration(seconds: 2),
                ))
              });
    }

    deleteTodo(String id) {
      Provider.of<Todos>(context, listen: false)
          .deleteTodo(id)
          .then((_) => Navigator.of(context).popUntil(ModalRoute.withName('/')))
          .then((_) => Scaffold.of(context).hideCurrentSnackBar())
          .then((_) => {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Deleted your Todo!',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ))
              });
    }

    switchFavTodo(String id, bool favVal) {
      Provider.of<Todos>(context, listen: false)
          .switchFav(id, favVal)
          .then((_) => Navigator.of(context).popUntil(ModalRoute.withName('/')))
          .then((_) => Scaffold.of(context).hideCurrentSnackBar())
          .then((_) => {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    favVal
                        ? 'Todo marked as Not Important'
                        : 'Todo marked as Important',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.lightGreen,
                  duration: Duration(seconds: 2),
                ))
              });
    }

    _showDialog(BuildContext ctx, int index, String editText) {
      _editTextC.text = editText;
      return showDialog(
          context: ctx,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 200,
                width: 400,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _editTextC,
                        onSubmitted: (_) =>
                            updatingTodos(todoItems[index].id, _editTextC.text),
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
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () =>
                            updatingTodos(todoItems[index].id, _editTextC.text),
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    _showModel(BuildContext ctx, int index, String editText, bool favVal) {
      return showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return GestureDetector(
                child: Container(
                  color: Colors.grey[900],
                  height: 210,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          favVal
                              ? "Mark As Not Important"
                              : "Mark as Important",
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                        onTap: () => switchFavTodo(todoItems[index].id, favVal),
                        trailing: IconButton(
                            icon: favVal
                                ? Icon(Icons.star)
                                : Icon(Icons.star_border),
                            color: Colors.yellow,
                            onPressed: () =>
                                switchFavTodo(todoItems[index].id, favVal)),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: Text(
                          "Edit",
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                        onTap: () => _showDialog(ctx, index, editText),
                        trailing: IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.grey[200],
                            onPressed: () => _showDialog(ctx, index, editText)),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: Text(
                          "Delete",
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.delete_outline),
                            color: Colors.red,
                            onPressed: () => deleteTodo(todoItems[index].id)),
                        onTap: () => deleteTodo(todoItems[index].id),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
                behavior: HitTestBehavior.opaque);
          });
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[900],
      child: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (BuildContext ctx, index) {
          return ListTile(
            trailing: IconButton(
                icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () => _showModel(context, index,
                    todoItems[index].text, todoItems[index].isFav)),
            title: Text(
              todoItems[index].text,
              softWrap: true,
              maxLines: 2,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Added On :- ${todoItems[index].addedOn}',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
