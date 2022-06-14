import 'package:dartz/dartz.dart';
import '../../../../modules/clients/domain/entities/client_result.dart';
import '../../../../modules/clients/domain/errors/errors.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<ClientResult>>> getClientById(int id);
  Future<Either<Failure, List<ClientResult>>> getClientAll();
  Future<Either<Failure, List<ClientResult>>> addClient(ClientResult client);
  Future<Either<Failure, List<ClientResult>>> updateClient(ClientResult client);
  Future<Either<Failure, bool>> deleteClientById(int id);
}
