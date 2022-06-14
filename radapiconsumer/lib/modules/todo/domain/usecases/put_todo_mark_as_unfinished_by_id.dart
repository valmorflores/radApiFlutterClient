import 'package:dartz/dartz.dart';
import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/domain/repositories/todo_repository.dart';

mixin PutTodoMarkAsUnfinishedById {
  Future<Either<Failure, List<TodoResult>>> call(int id);
}

class PutTodoMarkAsUnfinishedByIdImpl implements PutTodoMarkAsUnfinishedById {
  final TodoRepository repository;

  PutTodoMarkAsUnfinishedByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<TodoResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.putMarkAsUnfinished(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
