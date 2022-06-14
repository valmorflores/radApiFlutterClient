import 'package:dartz/dartz.dart';

import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/domain/repositories/todo_repository.dart';

mixin GetTodoAll {
  Future<Either<Failure, List<TodoResult>>> call();
}

//? @Injectable(singleton: false)
class GetTodoAllImpl implements GetTodoAll {
  final TodoRepository repository;

  GetTodoAllImpl(this.repository);

  @override
  Future<Either<Failure, List<TodoResult>>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getAll();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
