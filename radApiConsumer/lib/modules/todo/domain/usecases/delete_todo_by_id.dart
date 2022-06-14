// Update todo
import 'package:dartz/dartz.dart';

import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/domain/repositories/todo_repository.dart';

mixin DeleteTodoById {
  Future<Either<Failure, bool>> call(TodoResult todo);
}

class DeleteTodoByIdImpl implements DeleteTodoById {
  final TodoRepository repository;

  DeleteTodoByIdImpl(this.repository);

  @override
  Future<Either<Failure, bool>> call(TodoResult todo) async {
    var option = optionOf(todo);

    return option.fold(() => Left(InvalidSearchText()), (todo) async {
      var result = await repository.deleteById(todo);
      return result.fold(
          (l) => left(l), (r) => r ? left(EmptyList()) : right(r));
    });
  }
}
