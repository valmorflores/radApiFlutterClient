import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/entities/person_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';
import '/modules/workspaces/domain/repositories/person_repository.dart';

mixin GetById {
  Future<Either<Failure, List<PersonResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetByIdImpl implements GetById {
  final PersonRepository repository;

  GetByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<PersonResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getById(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
