import 'package:dartz/dartz.dart';
import '../../../../modules/clients/domain/entities/client_result.dart';
import '../../../../modules/clients/domain/errors/errors.dart';
import '../../../../modules/clients/domain/repositories/client_repository.dart';
import '../../../../modules/clients/infra/datasources/clients_datasource.dart';
import '../../../../modules/clients/infra/models/client_model.dart';
import 'package:flutter/cupertino.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientsDatasource datasource;

  ClientRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ClientResult>>> getClientAll() async {
    // TODO: implement getById
    List<ClientModel> list;

    try {
      list = await datasource.getAll();
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<ClientResult>>> addClient(
      ClientResult clientModel) async {
    List<ClientModel> list;
    try {
      list = await datasource.clientAdd(clientModel as ClientModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<ClientResult>>> getClientById(int id) async {
    List<ClientModel> list;
    try {
      list = await datasource.getById(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, bool>> deleteClientById(int id) async {
    bool lOk;
    try {
      lOk = await datasource.deleteClientById(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return lOk == null ? left(DatasourceResultNull()) : right(lOk);
  }

  @override
  Future<Either<Failure, List<ClientResult>>> updateClient(
      ClientResult clientResult) async {
    List<ClientModel> list;
    try {
      list = await datasource.updateById(clientResult as ClientModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
