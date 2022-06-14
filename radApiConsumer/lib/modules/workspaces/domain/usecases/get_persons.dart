import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/entities/person_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';
import '/modules/workspaces/domain/repositories/person_repository.dart';

mixin GetPersons {
  Future<Either<Failure, List<PersonResult>>> call(String text);
}

//? @Injectable(singleton: false)
class GetPersonsImpl implements GetPersons {
  final PersonRepository repository;

  GetPersonsImpl(this.repository);

  @override
  Future<Either<Failure, List<PersonResult>>> call(String text) async {
    var option = optionOf(text);

    return option.fold(() => Left(InvalidSearchText()), (text) async {
      var result = await repository.getPersons(text);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
