import 'package:dartz/dartz.dart';
import '/modules/keys/domain/entities/key_result.dart';
import '/modules/keys/domain/errors/errors.dart';

abstract class KeyRepository {
  Future<Either<Failure, List<KeyResult>>> getByKey(String searchText);
  Future<Either<Failure, List<KeyResult>>> getById(int id);
}
