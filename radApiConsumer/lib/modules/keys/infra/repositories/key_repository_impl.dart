import 'package:dartz/dartz.dart';
import '/modules/keys/domain/errors/errors.dart';
import '/modules/keys/domain/entities/key_result.dart';
import '/modules/keys/domain/repositories/key_repository.dart';
import '/modules/keys/infra/datasources/key_datasource.dart';
import '/modules/keys/infra/models/key_model.dart';
import 'package:flutter/cupertino.dart';

class KeyRepositoryImpl implements KeyRepository {
  final KeyDatasource datasource;

  KeyRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<KeyResult>>> getById(int id) async {
    List<KeyModel> list;
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
  Future<Either<Failure, List<KeyResult>>> getByKey(String searchText) async {
    List<KeyModel> list;
    try {
      list = await datasource.getByKey(searchText);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
