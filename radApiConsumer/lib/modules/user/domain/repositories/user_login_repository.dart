import 'package:dartz/dartz.dart';
import '../entities/user_login_result.dart';
import '../errors/errors.dart';

abstract class UserLoginRepository {
  Future<Either<Failure, List<UserLoginResult>>> postLogin(
      String email, String password);
}
