import 'package:dartz/dartz.dart';
import '../entities/user_login_result.dart';
import '../repositories/user_login_repository.dart';
import '../errors/errors.dart';

mixin PostUserLogin {
  Future<Either<Failure, List<UserLoginResult>>> call(
      String email, String password);
}

class UserLoginImpl implements PostUserLogin {
  final UserLoginRepository repository;

  UserLoginImpl(this.repository);

  @override
  Future<Either<Failure, List<UserLoginResult>>> call(
      String email, String password) async {
    var option = optionOf(email);
    if (email.isEmpty) {
      return Left(ErrorEmptyEmail());
    }
    if (password.isEmpty) {
      return Left(ErrorEmptyPassword());
    }
    return option.fold(() => Left(InvalidSearchText()), (email) async {
      var result = await repository.postLogin(email, password);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
