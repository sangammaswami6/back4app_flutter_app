import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/constants.dart';

class TodoUtils {

 // static final Uri _baseUrl = "https://parseapi.back4app.com/classes/";
  static final Uri _baseUrl = Uri.parse("https://parseapi.back4app.com/classes/");

  //CREATE
  static Future<Response> addTodo(Todo todo) async{
    String apiUrl = _baseUrl.resolve("Todo").toString();
    //String apiUrl = _baseUrl + "Todo";

    Response response = await post(Uri.parse(apiUrl),
      headers: {
        'X-Parse-Application-Id' : kParseApplicationId,
        'X-Parse-REST-API-Key' : kParseRestApiKey,
        'Content-Type' : 'application/json'
      },
      body: json.encode(todo.toJson()),
    );

    return response;
  }


  //READ
  static Future getTodoList() async{
    String apiUrl = _baseUrl.resolve("Todo").toString();
   // String apiUrl = _baseUrl + "Todo";

    Response response = await get(Uri.parse(apiUrl), headers: {
      'X-Parse-Application-Id' : kParseApplicationId,
      'X-Parse-REST-API-Key' : kParseRestApiKey,
    });

    return response;
  }
  
  
  //UPDATE
  static Future updateTodo(Todo todo) async{
    String apiUrl = _baseUrl.resolve("Todo/${todo.objectId}").toString();
    //String apiUrl = _baseUrl + "Todo/${todo.objectId}";
    
    Response response = await put(Uri.parse(apiUrl), headers: {
      'X-Parse-Application-Id' : kParseApplicationId,
      'X-Parse-REST-API-Key' : kParseRestApiKey,
      'Content-Type' : 'application/json',
    },
      body: json.encode(todo.toJson())
    );

    return response;
  }


  //DELETE
  static Future deleteTodo(String objectId) async{
      String apiUrl = _baseUrl.resolve("Todo/$objectId").toString();
    //String apiUrl = _baseUrl + "Todo/$objectId";

    Response response = await delete(Uri.parse(apiUrl), headers: {
      'X-Parse-Application-Id' : kParseApplicationId,
      'X-Parse-REST-API-Key' : kParseRestApiKey,
    });

    return response;
  }



}
