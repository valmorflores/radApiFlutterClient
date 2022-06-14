import 'dart:convert';

import 'package:dartz/dartz_unsafe.dart';
import 'package:dio/dio.dart';
import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/infra/constants/enum_staterecords.dart';
import '/modules/todo/infra/controllers/todo_items_controller.dart';
import '/modules/todo/infra/datasources/todo_datasource.dart';
import '/modules/todo/infra/models/todo_item_status.dart';
import '/modules/todo/infra/models/todo_model.dart';
import '/utils/globals.dart';
import 'package:flutter/material.dart';

class EIAPITodoDatasource implements TodoDatasource {
  final Dio dio;

  EIAPITodoDatasource(this.dio);

  @override
  Future<List<TodoModel>> getById(int id) async {
    debugPrint('f8732 - EIAPI_TODO_DATASOURCE_ via getById');
    var url = app_urlapi + "/todo/$id";
    debugPrint('f8732 - TODO: Running getById (API) from: ' + url);
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      var jsonList = result.data['data']; // as List;
      List<TodoModel> list = [];
      debugPrint('f8732 - Getting data');
      list.add(TodoModel.fromJson(jsonList));
      return list;
    } else {
      debugPrint('f8732 - error');
      throw Exception();
    }
  }

  @override
  Future<List<TodoModel>> getAll() async {
    debugPrint('f8784 - EIAPI_TODO_DATASOURCE_ via getAll');
    var url = app_urlapi + "/todo";
    debugPrint('f8784 - url: ' + url);
    var result = await this.dio.get(url);
    //var result = await this.dio.get(app_urlapi + "/contacts");
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => TodoModel(
                todoid: item['todoid'],
                description: item['description'],
                dateadded: item['dateadded'],
                timeadded: item['timeadded'],
                finished: item['finished'] == '1',
              ))
          .toList();
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<TodoModel>> updateById(TodoModel todoitem) async {
    debugPrint('f7401 - updateById running: todoid => ${todoitem.todoid}');
    var url = app_urlapi +
        "/todo/${todoitem.todoid}?description=${todoitem.description}";
    debugPrint('f7401: Running (API) from: ' + url);
    var list = {'description': todoitem.description, 'todoid': todoitem.todoid};
    var result = await this.dio.put(url, data: jsonEncode(list));
    if (result.statusCode == 200) {
      debugPrint('f7401: Sucesso no retorno...');
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => TodoModel(
                todoid: item['todoid'],
                description: item['description'],
                dateadded: item['dateadded'],
                timeadded: item['timeadded'],
              ))
          .toList();
      return list;
    } else {
      debugPrint('f7401: Erro no retorno...');
      throw Exception();
    }
  }

  @override
  Future<List<TodoModel>> getAllHeaders() async {
    // TODO: implement markAsFinishedById
    throw UnimplementedError();
  }

  @override
  Future<List<TodoModel>> markAsFinishedById(int id) async {
    debugPrint('f1284 - EIAPI_TODO_DATASOURCE_ mark as finished');
    var url = app_urlapi + "/todo/" + id.toString() + '/mark/finished';
    debugPrint('f1284 - url: ' + url);
    var result = await this.dio.put(url, data: jsonEncode({'todoid': id}));
    if (result.statusCode == 200) {
      debugPrint('f1284 - ' + result.data.toString());
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => TodoModel(
                todoid: item['todoid'],
                description: item['description'],
                dateadded: item['dateadded'],
                timeadded: item['timeadded'],
                finished: (item['finished'] == '1'),
              ))
          .toList();
      return list;
    } else {
      debugPrint('f1284 - error != 200');
      throw Exception();
    }
  }

  @override
  Future<List<TodoModel>> markAsUnfinishedById(int id) async {
    debugPrint('f1284 - EIAPI_TODO_DATASOURCE_ mark as unfinished');
    var url = app_urlapi + "/todo/" + id.toString() + '/mark/unfinished';
    debugPrint('f1284 - url: ' + url);
    var result = await this.dio.put(url, data: jsonEncode({'todoid': id}));
    if (result.statusCode == 200) {
      debugPrint('f1284 - ' + result.data.toString());
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => TodoModel(
                todoid: item['todoid'],
                description: item['description'],
                dateadded: item['dateadded'],
                timeadded: item['timeadded'],
                finished: (item['finished'] == '1'),
              ))
          .toList();
      debugPrint('f1284 - done with result');
      return list;
    } else {
      debugPrint('f1284 - error != 200');
      throw Exception();
    }
  }

  @override
  Future<List<TodoModel>> todoAdd(String description) async {
    debugPrint('f8884 - EIAPI_TODO_DATASOURCE_ add');
    var url = app_urlapi + "/todo" + '?description=' + description;
    debugPrint('f8884 - url: ' + url);
    debugPrint('f8884 - description: ' + description);
    var result =
        await this.dio.post(url, data: jsonEncode({description: description}));
    if (result.statusCode == 200) {
      debugPrint('f8884 - ' + result.data.toString());
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => TodoModel(
                todoid: item['todoid'],
                description: item['description'],
                dateadded: item['dateadded'],
                timeadded: item['timeadded'],
                finished: item['finished'] == '1',
              ))
          .toList();
      debugPrint('f8884 - done with result');
      return list;
    } else {
      debugPrint('f8884 - error != 200');
      throw Exception();
    }
  }

  @override
  Future<List<TodoModel>> searchText(String textSearch) {
    // TODO: implement searchText
    throw UnimplementedError();
  }

  @override
  Future<List<TodoModel>> updateMulti(
      TodoItemsController todoItemsController) async {
    List<TodoModel> todos;
    // TODO: implement updateMulti
    // throw UnimplementedError();
    debugPrint('f7547 - [todo] Start multi update');
    List<TodoItemStatus> todoListToDo = todoItemsController.list;
    TodoItemStatus itemTodo;
    int i = 0;
    todos = [];
    todoListToDo.forEach((element) {
      debugPrint('f7547 - todoid:' +
          element.todoid.toString() +
          ' - Operation: ' +
          element.status.toString());
      itemTodo = todoListToDo[i];
      if (element.status == StatusRecord.stDeleted) {
        element.status = StatusRecord.stDeletedDone;
        element.todoModel = TodoModel();
        element.todoModel!.todoid = element.todoid;
        element.todoModel!.status = StatusRecord.stDeletedDone;
        try {
          this.deleteById(element.todoModel!);
          todos.add(element.todoModel!);
        } catch (e) {}
      }
      if (element.status == StatusRecord.stMarkAsFinished) {
        element.status = StatusRecord.stMarkAsFinishedDone;
        element.todoModel = TodoModel();
        element.todoModel!.todoid = element.todoid;
        element.todoModel!.status = StatusRecord.stMarkAsFinishedDone;
        try {
          this.markAsFinishedById(element.todoid!);
          todos.add(element.todoModel!);
        } catch (e) {}
      }
      if (element.status == StatusRecord.stMarkAsUnfinished) {
        element.status = StatusRecord.stMarkAsUnfinishedDone;
        element.todoModel = TodoModel();
        element.todoModel!.todoid = element.todoid;
        element.todoModel!.status = StatusRecord.stMarkAsUnfinishedDone;
        try {
          this.markAsUnfinishedById(element.todoid!);
          todos.add(element.todoModel!);
        } catch (e) {}
      }
      ++i;
    });
    debugPrint('f7547 - [todo] multi records update done');
    return todos.toList();
  }

  @override
  Future<bool> deleteById(TodoResult todoitem) async {
    debugPrint('f3084 - EIAPI_TODO_DATASOURCE_ delete');
    var url = app_urlapi + "/todo/" + todoitem.todoid.toString();
    debugPrint('f3084 - url: ' + url);
    var result =
        await this.dio.delete(url, data: jsonEncode({'todoid': todoitem}));
    if (result.statusCode == 200) {
      debugPrint('f3084 - ' + result.data.toString());
      debugPrint('f3084 - done with result');
      return true;
    } else {
      debugPrint('f3084 - error != 200');
      throw Exception();
    }
  }
}
