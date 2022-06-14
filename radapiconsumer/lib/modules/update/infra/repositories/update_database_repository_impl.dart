import 'package:dartz/dartz.dart';
import '/modules/update/domain/entities/update_result.dart';
import '/modules/update/domain/repositories/update_database_repository.dart';
import '/modules/update/infra/datasources/update_database_datasource.dart';
import '/modules/update/infra/models/update_model.dart';
import '/modules/update/domain/errors/errors.dart';
import 'package:flutter/cupertino.dart';

class UpdateDatabaseRepositoryImpl implements UpdateDatabaseRepository {
  final UpdateDatabaseDatasource datasource;

  UpdateDatabaseRepositoryImpl(
    this.datasource,
  );

  @override
  Future<Either<Failure, List<UpdateResult>>> getUpdate() async {
    // TODO: implement getById
    List<UpdateModel> list;

    try {
      list = await datasource.getUpdate();
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
