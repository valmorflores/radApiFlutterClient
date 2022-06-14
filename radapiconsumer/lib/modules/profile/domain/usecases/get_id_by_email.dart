import 'package:dartz/dartz.dart';
import '/modules/profile/domain/errors/erros.dart';
import '/modules/profile/domain/repositories/profile_repository.dart';

mixin GetIdByEmail {
  Future<Either<Failure, int>> call(String email);
}

//? @Injectable(singleton: false)
class GetIdByEmailImpl implements GetIdByEmail {
  final ProfileRepository repository;

  GetIdByEmailImpl(this.repository);

  @override
  Future<Either<Failure, int>> call(String email) async {
    var option = optionOf(email);

    return option.fold(() => Left(InvalidSearchText()), (email) async {
      var result = await repository.getIdByEmail(email);
      return result.fold(
          (l) => left(l), (r) => r <= 0 ? left(EmptyList()) : right(r));
    });
  }
}
