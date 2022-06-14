import 'package:dartz/dartz.dart';
import '../../../../modules/connection/domain/entities/connection_result.dart';
import '../../../../modules/connection/domain/errors/errors.dart';

abstract class ConnectionRepository {
  Future<Either<Failure, List<ConnectionResult>>> getConnectionById(int id);
  Future<Either<Failure, List<ConnectionResult>>> getConnectionAll();
  Future<Either<Failure, List<ConnectionResult>>> addConnection(
      ConnectionResult connection);
  Future<Either<Failure, List<ConnectionResult>>> updateConnection(
      ConnectionResult connection);
  Future<Either<Failure, bool>> deleteConnectionById(int id);
}
