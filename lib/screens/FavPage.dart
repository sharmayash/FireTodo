import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Todo.dart';
import '../provider/todos.dart';

class FavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Todo> todoItems = Provider.of<Todos>(context).favTodoList;

    switchFavTodo(String id, bool favVal) {
      Provider.of<Todos>(context, listen: false)
          .switchFav(id, favVal)
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[900],
      child: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (BuildContext ctx, index) {
          return ListTile(
            // onTap: () =>
            //     switchFavTodo(todoItems[index].id, todoItems[index].isFav),
            trailing: IconButton(
                icon: Icon(Icons.star),
                color: Colors.yellowAccent,
                onPressed: () =>
                    switchFavTodo(todoItems[index].id, todoItems[index].isFav)),
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
