import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/entities/person_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';
import '/modules/workspaces/domain/repositories/person_repository.dart';

mixin PostLogin {
  Future<Either<Failure, PersonResult>> call(String email, String password);
}

//? @Injectable(singleton: false)
class PostLoginImpl implements PostLogin {
  final PersonRepository repository;

  PostLoginImpl(this.repository);

  @override
  Future<Either<Failure, PersonResult>> call(
      String email, String password) async {
    var option = optionOf(email);

    return option.fold(() => Left(InvalidSearchText()), (e) async {
      var result = await repository.postLogin(email, password);
      return result.fold(
          (l) => left(l), (r) => r == null ? left(EmptyList()) : right(r));
    });
  }
}
