import 'package:dartz/dartz.dart';
import '/modules/update/domain/entities/update_result.dart';
import '/modules/update/domain/errors/errors.dart';

abstract class UpdateDatabaseRepository {
  Future<Either<Failure, List<UpdateResult>>> getUpdate();
}
