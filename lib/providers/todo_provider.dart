import 'package:flutter/foundation.dart';

import '../class/todo_class.dart';
import '../class/user_class.dart';
import '../service/todo_service.dart';

enum ProviderState {
  open, connecting, complete, error
}

class TodoProvider with ChangeNotifier {
  TodoService _todoService = TodoService();

  TodoProvider(){
    print("todo provider init");
  }

  ProviderState _state = ProviderState.open;
  ProviderState get state => this._state;
  set state(ProviderState s) => throw "error";

  User? _user;
  User? get user => this._user;
  set user(User? u) => throw "error";

  List<Todo> _todos = [];
  List<Todo> get todos => this._todos.where((Todo todo) => todo.isChecked == false).toList();
  set todos(List<Todo> t) => throw "error";

  List<Todo> get checkedTodos => this._todos.where((Todo todo) => todo.isChecked == true).toList();
  set checkedTodos(List<Todo> t) => throw "error";

  List<Map<String, dynamic>> _editingTodos = [];

  String _newTodoTitle = "";

  bool _isEditMode = false;
  bool get isEditMode => this._isEditMode;
  set isEditMode(bool b) => throw "error";

  bool _isAddingTodo = false;
  bool get isAddingTodo => this._isAddingTodo;
  set isAddingTodo(bool b) => throw "error";

  void logOut(){
    this._state = ProviderState.open;
    this._todos = [];
    this._editingTodos = [];
  }

  void addMode(){
    this._isAddingTodo = !this._isAddingTodo;
    this.notifyListeners();
  }

  void editMode(){
    if (this._isEditMode && this._editingTodos.isNotEmpty) this._updateTodo();
    this._isEditMode = !this._isEditMode;
    this.notifyListeners();
  }

  void onChangedNew(String s) => this._newTodoTitle = s;

  Future<void> getTodos({required User user}) async {
    this._state = ProviderState.connecting;
    this._user = user;
    final Map<String, dynamic> _res = await this._todoService.getTodo(user: user);
    if (_res.containsKey("todos")) {
      this._todos = _res["todos"];
      this._state = ProviderState.complete;
    } else {
      this._state = ProviderState.error;
    }
    this.notifyListeners();
  }

  Future<void> addTodo() async {
    assert(this.user != null, "user is null");
    if (this.user == null) return; //todo error handling
    final Map<String, dynamic> _res = await this._todoService.addTodo(user: this.user!, title: this._newTodoTitle);
    if (_res.containsKey("todo")) {
      this._todos.add(Todo.fromJson(_res["todo"]));
      this.addMode();
    }
    if (_res.containsKey("error")) {
      // todo error handling
    }
  }

  Future<void> onCheckTodo(Todo todo) async {
    assert(this.user != null, "user is null");
    if (this.user == null) return; //todo error handling

    final Map<String, dynamic> _res = await this._todoService.checkTodo(user: this.user!, todoUid: todo.todoUid, isChecked: !todo.isChecked);
    if (_res.containsKey("data")) {
      final int _index = this._todos.indexWhere((Todo td) => td.todoUid == todo.todoUid);
      this._todos[_index] = Todo(todoUid: todo.todoUid, title: todo.title, isChecked: !todo.isChecked);
      this.notifyListeners();
    }
    if (_res.containsKey("error")) {
      // todo error handling
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    assert(this.user != null, "user is null");
    if (this.user == null) return; //todo error handling
    final Map<String, dynamic> _res = await this._todoService.deleteTodo(user: this.user!, todoUid: todo.todoUid);
    if (_res.containsKey("data")){
      this._todos.removeWhere((Todo td) => td.todoUid == todo.todoUid);
      this.notifyListeners();
    }
  }

  void onChangedOld(String s, Todo todo) {
    final int _todoIndex = this._todos.indexWhere((Todo td) => td.todoUid == todo.todoUid);
    final int _editingIndex = this._editingTodos.indexWhere((Map<String, dynamic> todo) => todo["index"] == _todoIndex);
    if (_editingIndex == -1){
      this._editingTodos.add({"index": _todoIndex, "newTitle": s, "todoUid": this._todos[_todoIndex].todoUid});
    } else {
      this._editingTodos[_editingIndex]["newTitle"] = s;
    }
  }

  Future<void> _updateTodo() async {
    assert(this._user != null, "user is null");
    if (this._user == null) return; //todo error handling

    this._editingTodos.forEach((Map<String, dynamic> edited) {
      this._todos[edited["index"]] = Todo(title: edited["newTitle"], todoUid: edited["todoUid"], isChecked: false);
    });
    final List<Map<String, dynamic>> _updatedTodos = this._editingTodos.map((Map<String, dynamic> td) {
      return {"path": "${td["todoUid"]}/title", "title": "${td["newTitle"]}"};
    }).toList();
    print(_updatedTodos);
    final bool _success = await this._todoService.updateTodo(user: this._user!, updatedTodos: _updatedTodos);
    if (!_success) {

    } else {

    }
    this._editingTodos = [];
  }

}