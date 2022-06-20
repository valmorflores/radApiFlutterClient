import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/table_data_result.dart';
import '../../domain/errors/errors.dart';
import '../../domain/repositories/table_data_repository.dart';
import '../datasource/table_data_datasource.dart';
import '../models/table_data_model.dart';

class TableFieldRepositoryImpl implements TableDataRepository {
  final TableDataDatasource datasource;

  TableFieldRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<TableDataResult>>> getTableFieldAll(String tableName) async {
    List<TableDataModel> list;
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
