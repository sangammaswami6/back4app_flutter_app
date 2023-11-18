import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/network_utils/todo_utils.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
 TextEditingController _taskController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();


  
 
 GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // Example color constants
const Color primaryColor = Colors.green;
const Color secondaryColor = Colors.blue;
// Example snackbar style


// Example text style
const TextStyle headlineStyle = TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.brown,);//backgroundColor: Colors.lightBlue,);


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Task Manager", style: headlineStyle,),
      ),
      body: Container(
        child:
		FutureBuilder(builder: (context, snapshot) {
          
          if (snapshot.data != null) {
            List<Todo> todoList = snapshot.data ?? [];
            return ListView.builder(itemBuilder: (_, position) {
              return ListTile(
                title: Text(todoList[position].task),
                subtitle: Text(todoList[position].description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.edit, color:Colors.green,), onPressed: () {
                      //Show dialog box to update item
                       showUpdateDialog(todoList[position]);
                    }),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: () {
                      //Show dialog box to delete item
                       deleteTodo(todoList[position].objectId);
                    })
                  ],
                ),
              );
            },
              itemCount: todoList.length,
            );

          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
          future: getTodoList(),
        ),
      ),
  floatingActionButton: FloatingActionButton(onPressed: () {
    showAddTodoDialog();
      },
      
        child: Icon(Icons.task,color: Colors.green,),
      ),
    );
  }



  Future <List<Todo>> getTodoList() async{
    List<Todo> todoList = [];

    Response response = await TodoUtils.getTodoList();
    print("Code is ${response.statusCode}");
    print("Response is ${response.body}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var results = body["results"];

      for (var todo in results) {
        todoList.add(Todo.fromJson(todo));
      }

    } else {
       print("Handle error");
      //Handle error
    }

    return todoList;
  }
 Color primaryColor = Colors.green; 
 void showAddTodoDialog() {
 
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: "Enter task",
              border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),),
            ),
          ),
          SizedBox(height: 16.0), // Add some space between the fields
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Enter description",
               border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            addTodo();
          },
          child: Text("Add"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    ),
  );
}
  void addTodo() {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        Text("Adding task"),
        CircularProgressIndicator(),
      ],
     
    ),
      duration: Duration(minutes: 1),
    ));

    Todo todo = Todo(task: _taskController.text,description:_descriptionController.text);

    TodoUtils.addTodo(todo)
    .then((res) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Response response = res;
      if (response.statusCode == 201) {
        //Successful
        _taskController.text = "";
        _descriptionController.text="";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row( 
        children: [Text("Todo added!")], ),duration: Duration(seconds: 1),));

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
        setState(() {
          //Update UI
        });

      }

    });

  }
 
 void showUpdateDialog(Todo todo) {

    _taskController.text = todo.task;
    _descriptionController.text=todo.description;
    showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: "Enter updated task",
                  border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),),
            ),
          ),
          SizedBox(height: 16.0), // Add some space between the fields
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Enter updated task description",
                  border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),),
            ),
          ),
        ],
      ),
        actions: <Widget>[
          ElevatedButton(onPressed: () {
            Navigator.pop(context);
            todo.task = _taskController.text;
            todo.description = _descriptionController.text;
            updateTodo(todo);
          }, child: Text("Update")),
          ElevatedButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Cancel")),
        ],
      )
    );
    
  }


  void updateTodo(Todo todo) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Updating todo"),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);


    TodoUtils.updateTodo(todo)
    .then((res) {

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 200) {
        //Successfully Deleted
        _taskController.text = "";
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: (Text("Updated!"))));
        setState(() {

        });
      } else {
        //Handle error
      }
    });
    
  }

void deleteTodo(String objectId) {

     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  <Widget>[
        Text("Deleting todo"),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);


    TodoUtils.deleteTodo(objectId)
      .then((res) {

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        Response response = res;
        if (response.statusCode == 200) {
          //Successfully Deleted
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: (Text("Deleted!")),duration: Duration(seconds: 1),));
          setState(() {

          });
        } else {
          //Handle error
        }
    });

  }

}