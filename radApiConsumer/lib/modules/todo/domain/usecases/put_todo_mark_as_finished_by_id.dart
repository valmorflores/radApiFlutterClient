import 'package:dartz/dartz.dart';
import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/domain/repositories/todo_repository.dart';

mixin PutTodoMarkAsFinishedById {
  Future<Either<Failure, List<TodoResult>>> call(int id);
}

class PutTodoMarkAsFinishedByIdImpl implements PutTodoMarkAsFinishedById {
  final TodoRepository repository;

  PutTodoMarkAsFinishedByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<TodoResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.putMarkAsFinished(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
