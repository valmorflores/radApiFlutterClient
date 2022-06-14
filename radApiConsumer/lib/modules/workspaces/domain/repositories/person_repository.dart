import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/entities/person_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<PersonResult>>> getByAlias(String searchText);
  Future<Either<Failure, List<PersonResult>>> getAll();
  Future<Either<Failure, List<PersonResult>>> getById(int id);
  Future<Either<Failure, List<PersonResult>>> getPersons(String searchText);
  Future<Either<Failure, PersonResult>> postLogin(
      String email, String password);
}
