import 'package:dartz/dartz.dart';
import '/modules/profile/domain/entities/profile_result.dart';
import '/modules/profile/domain/errors/erros.dart';
import '/modules/profile/domain/repositories/profile_repository.dart';

mixin GetUsers {
  Future<Either<Failure, List<ProfileResult>>> call(String text);
}

//? @Injectable(singleton: false)
class GetUsersImpl implements GetUsers {
  final ProfileRepository repository;

  GetUsersImpl(this.repository);

  @override
  Future<Either<Failure, List<ProfileResult>>> call(String text) async {
    var option = optionOf(text);

    return option.fold(() => Left(InvalidSearchText()), (text) async {
      var result = await repository.getUsers(text);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
