import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/infra/controllers/todo_items_controller.dart';
import '/modules/todo/infra/models/todo_model.dart';

abstract class TodoDatasource {
  Future<List<TodoModel>> searchText(String textSearch);
  Future<List<TodoModel>> getAll();
  Future<List<TodoModel>> getById(int id);
  Future<List<TodoModel>> todoAdd(String description);
  Future<List<TodoModel>> updateById(TodoModel todoitem);
  Future<bool> deleteById(TodoResult todoitem);
  Future<List<TodoModel>> markAsFinishedById(int id);
  Future<List<TodoModel>> markAsUnfinishedById(int id);
  Future<List<TodoModel>> updateMulti(TodoItemsController todoItemsController);
}
