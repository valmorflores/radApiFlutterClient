// Status de cada item para adicionar na lista
import '/modules/todo/infra/constants/enum_staterecords.dart';

import 'todo_model.dart';

class TodoItemStatus {
  int? todoid;
  int? index;
  StatusRecord? status;
  TodoModel? todoModel;
  TodoItemStatus({this.todoid, this.index, this.todoModel, this.status});

  void setTodo(TodoModel todoModel) {
    this.todoModel = todoModel;
  }
}
