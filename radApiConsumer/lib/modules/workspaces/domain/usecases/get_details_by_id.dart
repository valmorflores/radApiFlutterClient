import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/entities/person_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';
import '/modules/workspaces/domain/repositories/person_repository.dart';

mixin GetDetailsById {
  Future<Either<Failure, List<PersonResult>>> call(String id);
}

//? @Injectable(singleton: false)
class GetDetailsByIdImpl implements GetDetailsById {
  final PersonRepository repository;

  GetDetailsByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<PersonResult>>> call(String id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getByAlias(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
