import 'package:flutter/cupertino.dart';

import '../../providers/auth_provider.dart';
import '../../providers/todo_provider.dart';
import 'ios_components.dart';

class IosMain extends StatelessWidget {
  const IosMain({Key? key, required this.authProvider, required this.todoProvider}) : super(key: key);
  final AuthProvider authProvider;
  final TodoProvider todoProvider;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.person, size: 28.0),
          onPressed: () async {
            await this.authProvider.firebaseSignOut();
            this.todoProvider.logOut();
          },
        ),
        middle: Text("Your Todos"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(this.todoProvider.isEditMode ? "Save" : "Edit"),
          onPressed: this.todoProvider.editMode,
        ),
      ),
      child: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              !this.todoProvider.isAddingTodo
                  ? AddTodo(addTodo: this.todoProvider.addMode,)
                  : IosNewTodo(
                saveTodo: this.todoProvider.addTodo,
                cancel: this.todoProvider.addMode,
                onChanged: this.todoProvider.onChangedNew,
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: this.todoProvider.todos.length,
                  itemBuilder: (_, int index) => IosTodo(
                    onChangedTodo: this.todoProvider.onChangedOld,
                    checkTodo: this.todoProvider.onCheckTodo,
                    isEditMode: this.todoProvider.isEditMode,
                    todo: this.todoProvider.todos[index],
                    deleteTodo: this.todoProvider.deleteTodo,
                  ),
                ),
              ),
              this.todoProvider.checkedTodos.isNotEmpty
                  ? Container(
                height: 55.0 + 30.0 * this.todoProvider.checkedTodos.length,
                child: Column(
                  children: <Widget>[
                    Text("Checked Todos"),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 5.0),
                        itemCount: this.todoProvider.checkedTodos.length,
                        itemBuilder: (_, int index) => CheckedTodo(
                          uncheckTodo: this.todoProvider.onCheckTodo,
                          todo: this.todoProvider.checkedTodos[index],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
