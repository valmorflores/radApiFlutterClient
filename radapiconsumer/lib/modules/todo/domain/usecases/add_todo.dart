import 'package:dartz/dartz.dart';
import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/domain/repositories/todo_repository.dart';

mixin AddTodo {
  Future<Either<Failure, List<TodoResult>>> call(String name);
}

//? @Injectable(singleton: false)
class AddTodoImpl implements AddTodo {
  final TodoRepository repository;

  AddTodoImpl(this.repository);

  @override
  Future<Either<Failure, List<TodoResult>>> call(String name) async {
    var option = optionOf(name);

    return option.fold(() => Left(InvalidSearchText()), (name) async {
      var result = await repository.add(name);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
