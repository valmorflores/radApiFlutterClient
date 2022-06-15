import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/table_field_result.dart';
import '../../domain/errors/errors.dart';
import '../../domain/repositories/table_repository.dart';
import '../datasource/table_field_datasource.dart';
import '../models/table_field_model.dart';

class TableFieldRepositoryImpl implements TableFieldRepository {
  final TableFieldDatasource datasource;

  TableFieldRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<TableFieldResult>>> getTableFieldAll(String tableName) async {
    List<TableFieldModel> list;
    try {
      list = await datasource.getAll(tableName);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
