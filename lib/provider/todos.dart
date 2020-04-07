import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/Todo.dart';
import '../models/HttpException.dart';

class Todos with ChangeNotifier {
  List<Todo> _todoList = [];
  String _authToken;
  String _userId;

  Todos(this._authToken, this._userId, this._todoList);

  List<Todo> get todoList {
    return [..._todoList];
  }

  List<Todo> get favTodoList {
    return [..._todoList.where((todo) => todo.isFav == true)];
  }

  Future<void> fetchAndSetProducts() async {
    var url =
        'https://sy-todo-app.firebaseio.com/todo.json?auth=$_authToken&orderBy="user"&equalTo="$_userId"';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Todo> loadedProducts = [];
      extractedData.forEach((todoId, todoData) {
        loadedProducts.add(Todo(
            id: todoId,
            text: todoData['text'],
            user: todoData['user'],
            isFav: todoData['isFav'],
            addedOn: todoData['addedOn']));
      });
      _todoList = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTodo(Todo argTodo) async {
    var url = "https://sy-todo-app.firebaseio.com/todo.json?auth=$_authToken";
    try {
      final response = await http.post(url,
          body: json.encode({
            'text': argTodo.text,
            'user': _userId,
            'addedOn': argTodo.addedOn
          }));

      final newTodo = Todo(
          id: json.decode(response.body)['name'],
          text: argTodo.text,
          user: argTodo.user,
          addedOn: argTodo.addedOn,
          isFav: argTodo.isFav);

      _todoList.insert(0, newTodo);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateTodo(String id, String newTodoText) async {
    final todoIndex = _todoList.indexWhere((todo) => todo.id == id);
    if (todoIndex >= 0) {
      var url =
          "https://sy-todo-app.firebaseio.com/todo/$id.json?auth=$_authToken";
      await http.patch(url, body: json.encode({'text': newTodoText}));
      _todoList[todoIndex].text = newTodoText;
      notifyListeners();
    } else {
      print('-----');
    }
  }

  Future<void> deleteTodo(String id) async {
    final url =
        'https://sy-todo-app.firebaseio.com/todo/$id.json?auth=$_authToken';
    final existingTodoIndex = _todoList.indexWhere((todo) => todo.id == id);
    var existingTodo = _todoList[existingTodoIndex];
    _todoList.removeAt(existingTodoIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _todoList.insert(existingTodoIndex, existingTodo);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingTodo = null;
  }

  Future<void> switchFav(String id, bool favVal) async {
    final url =
        'https://sy-todo-app.firebaseio.com/todo/$id.json?auth=$_authToken';
    final indexOfTodo = _todoList.indexWhere((todo) => todo.id == id);
    await http.patch(url, body: json.encode({'isFav': !favVal}));
    _todoList[indexOfTodo].isFav = !favVal;
    notifyListeners();
  }
}
