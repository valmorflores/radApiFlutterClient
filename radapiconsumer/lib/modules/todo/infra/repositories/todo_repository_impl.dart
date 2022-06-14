import 'package:dartz/dartz.dart';
import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart' as error;
import '/modules/todo/domain/errors/errors_todo_statusrecord.dart'
    as error_statusrecord;
import '/modules/todo/domain/repositories/todo_repository.dart';
import '/modules/todo/infra/controllers/todo_items_controller.dart';
import '/modules/todo/infra/datasources/todo_datasource.dart';
import '/modules/todo/infra/models/todo_model.dart';
import 'package:flutter/cupertino.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDatasource datasource;

  TodoRepositoryImpl(
    this.datasource,
  );

  @override
  Future<Either<error.Failure, List<TodoResult>>> updateById(
      TodoResult task) async {
    List<TodoModel> list;
    try {
      list = await datasource.updateById(task as TodoModel);
    } on error.DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(error.ErrorSearch());
    }
    return list == null ? left(error.DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<error.Failure, List<TodoResult>>> add(
      String description) async {
    List<TodoModel> list;
    try {
      list = await datasource.todoAdd(description);
    } on error.DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(error.ErrorSearch());
    }
    return list == null ? left(error.DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<error.Failure, List<TodoResult>>> getAll() async {
    // TODO: implement getById
    List<TodoModel> list;

    try {
      list = await datasource.getAll();
    } on error.DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(error.ErrorSearch());
    }
    return list == null ? left(error.DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<error.Failure, List<TodoResult>>> getById(int id) async {
    List<TodoModel> list;
    try {
      list = await datasource.getById(id);
    } on error.DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(error.ErrorSearch());
    }
    return list == null ? left(error.DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<error.Failure, List<TodoResult>>> putMarkAsFinished(
      int id) async {
    // TODO: implement putMarkAsFinished
    throw UnimplementedError();
  }

  @override
  Future<Either<error.Failure, List<TodoResult>>> putMarkAsUnfinished(
      int id) async {
    // TODO: implement putMarkAsUnfinished
    throw UnimplementedError();
  }

  @override
  Future<Either<error_statusrecord.Failure, List<TodoResult>>> updateMulti(
      TodoItemsController itemsController) async {
    List<TodoModel> list;
    try {
      list = await datasource.updateMulti(itemsController);
    } on error_statusrecord.DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(error_statusrecord.ErrorSearch());
    }
    return list == null
        ? left(error_statusrecord.DatasourceResultNull())
        : right(list);
  }

  @override
  Future<Either<error.Failure, bool>> deleteById(TodoResult todoitem) async {
    bool lOk;
    try {
      lOk = await datasource.deleteById(todoitem);
    } on error.DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(error.ErrorSearch());
    }
    return lOk == null ? left(error.DatasourceResultNull()) : right(true);
  }
}
