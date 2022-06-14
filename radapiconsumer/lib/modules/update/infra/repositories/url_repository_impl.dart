import '/modules/update/domain/errors/errors.dart';
import '/modules/update/domain/entities/url_result.dart';
import 'package:dartz/dartz.dart';
import '/modules/update/domain/repositories/url_repository.dart';
import '/modules/update/infra/datasources/url_datasource.dart';
import '/modules/update/infra/models/url_model.dart';
import 'package:flutter/cupertino.dart';

class UrlRepositoryImpl implements UrlRepository {
  final UrlDatasource datasource;

  UrlRepositoryImpl(
    this.datasource,
  );

  @override
  Future<Either<Failure, UrlResult>> getAll() async {
    // TODO: implement getById
    UrlModel list;

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
}
