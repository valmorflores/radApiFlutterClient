// Update todo
import 'package:dartz/dartz.dart';

import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/domain/repositories/todo_repository.dart';

mixin UpdateTodoById {
  Future<Either<Failure, List<TodoResult>>> call(TodoResult todo);
}

class UpdateTodoByIdImpl implements UpdateTodoById {
  final TodoRepository repository;

  UpdateTodoByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<TodoResult>>> call(TodoResult todo) async {
    var option = optionOf(todo);

    return option.fold(() => Left(InvalidSearchText()), (todo) async {
      var result = await repository.updateById(todo);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
