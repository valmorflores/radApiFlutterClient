import 'package:dartz/dartz.dart';
import '../../../../modules/connection/domain/entities/connection_result.dart';
import '../../../../modules/connection/domain/errors/errors.dart';
import '../../../../modules/connection/infra/datasources/connection_datasource.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/repositories/connection_repository.dart';
import '../models/ConnectionModel.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionDatasource datasource;

  ConnectionRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ConnectionResult>>> addConnection(
      ConnectionResult connection) async {
    List<ConnectionModel> list;
    try {
      list = await datasource.connectionAdd(connection as ConnectionModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, bool>> deleteConnectionById(int id) async {
    bool lOk;
    try {
      lOk = await datasource.deleteConnectionById(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return lOk == null ? left(DatasourceResultNull()) : right(lOk);
  }

  @override
  Future<Either<Failure, List<ConnectionResult>>> getConnectionAll() async {
    // TODO: implement getById
    List<ConnectionModel> list;

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
  Future<Either<Failure, List<ConnectionResult>>> getConnectionById(
      int id) async {
    List<ConnectionModel> list;
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
  Future<Either<Failure, List<ConnectionResult>>> updateConnection(
      ConnectionResult connection) async {
    // TODO: implement updateConnection
    List<ConnectionModel> list;
    try {
      list = await datasource.updateById(connection as ConnectionModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
