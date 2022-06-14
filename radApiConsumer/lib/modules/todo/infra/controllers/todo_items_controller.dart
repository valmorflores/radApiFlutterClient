// TodoItemsController---start
import '/modules/todo/infra/constants/enum_staterecords.dart';
import '/modules/todo/infra/models/todo_item_status.dart';
import 'package:flutter/cupertino.dart';

import '../models/todo_model.dart';

class TodoItemsController {
  List<TodoItemStatus> todosStatus;

  TodoItemsController({required this.todosStatus}) {
    this.todosStatus = [];
  }

  get list => this.todosStatus;

  TodoItemStatus getById(todoid) {
    try {
      if (this.todosStatus == null) return defaultItem(todoId: todoid);
      return this.todosStatus.firstWhere((element) => element.todoid == todoid);
    } catch (e) {
      return defaultItem(todoId: todoid);
    }
  }

  TodoItemStatus defaultItem({required int todoId}) {
    return TodoItemStatus(
        todoid: todoId, todoModel: null, status: StatusRecord.stDataRecord);
  }

  StatusRecord getStatus(todoid) {
    StatusRecord x = StatusRecord.stDataRecord;
    if (this.todosStatus != null) {
      if (this.todosStatus.length > 0) {
        this.todosStatus.forEach((element) {
          if (element.todoid == todoid) {
            x = element.status!;
          }
        });
      }
    }
    return x;
  }

  int getPos(int todoid) {
    return todosStatus.indexWhere((element) {
      return (element.todoid == todoid);
    });
  }

  void removeStatus({required int todoid}) {
    this.todosStatus.removeWhere((element) => element.todoid == todoid);
  }

  void addStatus(
      {required int todoid, StatusRecord? status, TodoModel? todoModel}) {
    bool lexists = false;
    int i = 0;
    debugPrint('f7405 - AddStatus => todoid: ' +
        todoid.toString() +
        ' - ' +
        status.toString());
    if (this.todosStatus == null) {
      this.todosStatus = [];
    }
    this.todosStatus.forEach((element) {
      if (element.todoid == todoid) {
        TodoModel todoModelAplly;
        if (todoModel != null) {
          todoModelAplly = todoModel;
        } else {
          todoModelAplly = todosStatus[i].todoModel!;
        }
        if (!(todoModelAplly == null)) {
          todoModelAplly.status = status;
        }
        this.todosStatus[i] = TodoItemStatus(
            todoid: todoid, status: status, todoModel: todoModelAplly);
        lexists = true;
      }
      ++i;
    });
    if (!lexists) {
      todosStatus.add(
          TodoItemStatus(todoid: todoid, status: status, todoModel: todoModel));
    }
  }
}
