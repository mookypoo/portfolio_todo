import '../class/todo_class.dart';
import '../class/user_class.dart';
import '../repos/connect.dart';

class TodoService {
  Connect _connect = Connect();

  // todo check what kind of response you get
  Future<Map<String, dynamic>> addTodo({required User user, required String title}) async {
    final Map<String, dynamic> _body = {"userUid": user.userUid, "idToken": user.idToken, "title": title};
    try {
      final Map<String, dynamic> _res = await this._connect.reqPostServer(
          path: "/todos-todos/add", cb: (ReqModel rm) {}, body: _body);
      return _res;
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> getTodo({required User user}) async {
    final Map<String, dynamic> _body = {"userUid": user.userUid, "idToken": user.idToken};
    try {
      final Map<String, dynamic> _res = await this._connect.reqPostServer(path: "/todos/get", cb: (ReqModel rm) {}, body: _body);
      if (_res.containsKey("todos")) {
        List<Map<String, dynamic>>? _todos = List<Map<String, dynamic>>.from(_res["todos"]);
        List<Todo> _todoList = [];
        _todos.forEach((element) => _todoList.add(Todo.fromJson(element)));
        return {"todos": _todoList};
      }
      if (_res.containsKey("error")) {
        // todo error handling
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<bool> updateTodo({required User user, required List<Map<String, dynamic>> updatedTodos}) async {
    final Map<String, dynamic> _body = {
      "userUid": user.userUid,
      "idToken": user.idToken,
      "updatedTodos": updatedTodos,
    };
    try {
      final Map<String, dynamic> _res = await this._connect.reqPostServer(path: "/todos/update", cb: (ReqModel rm) {}, body: _body);
      if (_res.containsKey("data")) return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<Map<String, dynamic>> deleteTodo({required User user, required String todoUid}) async {
    final Map<String, dynamic> _body = {
      "userUid": user.userUid,
      "idToken": user.idToken,
      "todoUid": todoUid,
    };
    try {
      final Map<String, dynamic> _res = await this._connect.reqPostServer(path: "/todos/delete", cb: (ReqModel rm) {}, body: _body);
      return _res;
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> checkTodo({required User user, required String todoUid, required bool isChecked}) async {
    final Map<String, dynamic> _body = {
      "userUid": user.userUid,
      "idToken": user.idToken,
      "todoUid": todoUid,
      "isChecked": isChecked,
    };
    try {
      final Map<String, dynamic> _res = await this._connect.reqPostServer(path: "/todos/check", cb: (ReqModel rm) {}, body: _body);
      return _res;
    } catch (e) {
      print(e);
    }
    return {};
  }
}