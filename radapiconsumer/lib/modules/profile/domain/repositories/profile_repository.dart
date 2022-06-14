import 'package:dartz/dartz.dart';
import '/modules/profile/domain/entities/profile_result.dart';
import '/modules/profile/domain/errors/erros.dart';

abstract class ProfileRepository {
  Future<Either<Failure, List<ProfileResult>>> getUsers(String searchText);
  Future<Either<Failure, List<ProfileResult>>> getById(int id);
  Future<Either<Failure, List<ProfileResult>>> getDetailsById(int id);
  Future<Either<Failure, int>> getIdByEmail(String email);
}
