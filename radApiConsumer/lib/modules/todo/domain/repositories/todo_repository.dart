import 'package:dartz/dartz.dart';
import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/infra/controllers/todo_items_controller.dart';
import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/domain/errors/errors_todo_statusrecord.dart'
    as error_statusrecord;

abstract class TodoRepository {
  Future<Either<Failure, List<TodoResult>>> getById(int id);
  Future<Either<Failure, List<TodoResult>>> getAll();
  Future<Either<Failure, List<TodoResult>>> add(String description);
  Future<Either<Failure, List<TodoResult>>> updateById(TodoResult todoitem);
  Future<Either<Failure, bool>> deleteById(TodoResult todoitem);
  Future<Either<Failure, List<TodoResult>>> putMarkAsFinished(int id);
  Future<Either<Failure, List<TodoResult>>> putMarkAsUnfinished(int id);
  Future<Either<error_statusrecord.Failure, List<TodoResult>>> updateMulti(
      TodoItemsController itemsController);
}
