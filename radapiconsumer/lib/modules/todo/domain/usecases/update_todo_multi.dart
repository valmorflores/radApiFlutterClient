// Update todo
import 'package:dartz/dartz.dart';

import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors_todo_statusrecord.dart';
import '/modules/todo/domain/repositories/todo_repository.dart';
import '/modules/todo/infra/controllers/todo_items_controller.dart';

mixin UpdateTodoMulti {
  Future<Either<Failure, List<TodoResult>>> call(TodoItemsController todo);
}

class UpdateTodoMultiImpl implements UpdateTodoMulti {
  final TodoRepository repository;

  UpdateTodoMultiImpl(this.repository);

  @override
  Future<Either<Failure, List<TodoResult>>> call(
      TodoItemsController todo) async {
    var option = optionOf(todo);

    return option.fold(() => Left(InvalidSearchText()), (todo) async {
      var result = await repository.updateMulti(todo);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
