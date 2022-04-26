class Todo {
  final String title;
  final String todoUid;
  final bool isChecked;

  Todo({required this.title, required this.todoUid, required this.isChecked});

  Map<String, dynamic> toJson(){
    return {
      "title": this.title,
      "todo_uid": this.todoUid,
      "is_checked": this.isChecked,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json){
    return Todo(
      todoUid: json["todoUid"].toString(),
      title: json["title"].toString(),
      isChecked: json["isChecked"] as bool,
    );
  }

  Todo onCheck() => Todo(isChecked: !this.isChecked, title: this.title, todoUid: this.todoUid);
}