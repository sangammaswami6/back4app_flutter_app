import 'dart:convert';

List<Todo> todoFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  String objectId;
  String task;
  String description;

  Todo({
    this.objectId = '', // Provide a default value or use required.
    this.task = '',     // Provide a default value or use required.
    this.description='',
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    objectId: json["objectId"],
    task: json["task"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "objectId": objectId,
    "task": task,
    "description":description,
  };
}