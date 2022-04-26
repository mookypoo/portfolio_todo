import 'package:flutter/cupertino.dart';

import '../../class/todo_class.dart';

class AddTodo extends StatelessWidget {
  const AddTodo({Key? key, required this.addTodo}) : super(key: key);
  final void Function() addTodo;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: const Text("+ add new todo", style: TextStyle(color: CupertinoColors.black),),
      onPressed: this.addTodo,
    );
  }
}

class IosNewTodo extends StatelessWidget {
  const IosNewTodo({Key? key, required this.saveTodo, required this.cancel, required this.onChanged}) : super(key: key);
  final void Function() saveTodo;
  final void Function() cancel;
  final void Function(String s) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 15.0, bottom: 5.0, right: 5.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            width: 240.0,
            child: CupertinoTextField(
              onChanged: this.onChanged,
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.add),
            onPressed: this.saveTodo,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.xmark),
            onPressed: this.cancel,
          ),
        ],
      ),
    );
  }
}


class IosTodo extends StatefulWidget {
  const IosTodo({Key? key, required this.isEditMode, required this.todo, required this.checkTodo, required this.onChangedTodo, required this.deleteTodo}) : super(key: key);
  final bool isEditMode;
  final Todo todo;
  final void Function(Todo todo) checkTodo;
  final void Function(Todo todo) deleteTodo;
  final void Function(String s, Todo todo) onChangedTodo;

  @override
  State<IosTodo> createState() => _IosTodoState();
}

class _IosTodoState extends State<IosTodo> {
  final TextEditingController _textCt = TextEditingController();

  Widget _editForm({required TextEditingController ct, required Todo todo, required void Function(Todo todo) deleteTodo}){
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          width: 260.0,
          child: CupertinoTextField(
            onChanged: (String s) => this.widget.onChangedTodo(s, todo),
            controller: ct..text = todo.title,
            decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.only(top: 5.0),
          child: const Icon(CupertinoIcons.delete, size: 22.0,),
          onPressed: () => deleteTodo(todo),
        ),
      ],
    );
  }

  Widget _viewForm({required String title}){
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      width: 260.0,
      child: Text(title),
    );
  }

  @override
  void dispose() {
    this._textCt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      margin: const EdgeInsets.only(left: 25.0, right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => this.widget.checkTodo(this.widget.todo),
            child: Container(
              width: 14.0,
              height: 14.0,
              decoration: BoxDecoration(border: Border.all()),
            ),
          ),
          this.widget.isEditMode ? this._editForm(ct: this._textCt, todo: this.widget.todo, deleteTodo: this.widget.deleteTodo) : this._viewForm(title: this.widget.todo.title),
        ],
      ),
    );
  }
}

class CheckedTodo extends StatelessWidget {
  const CheckedTodo({Key? key, required this.uncheckTodo, required this.todo}) : super(key: key);
  final void Function(Todo todo) uncheckTodo;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      margin: const EdgeInsets.only(left: 25.0, right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => this.uncheckTodo(this.todo),
            child: Stack(
              children: <Widget>[
                Icon(CupertinoIcons.check_mark, size: 27.0, color: Color.fromRGBO(0,0,0, 1.0)),
                Positioned(
                  bottom: 4.0,
                  left: 5.0,
                  child: Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            width: 260.0,
            child: Text(todo.title, style: TextStyle(decoration: TextDecoration.lineThrough),),
          ),
        ],
      ),
    );
  }
}



