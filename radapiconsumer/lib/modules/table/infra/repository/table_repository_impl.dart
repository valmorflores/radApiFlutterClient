import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/table_result.dart';
import '../../domain/errors/errors.dart';
import '../../domain/repositories/table_repository.dart';
import '../datasource/table_datasource.dart';
import '../models/table_model.dart';

class TableRepositoryImpl implements TableRepository {
  final TableDatasource datasource;

  TableRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<TableResult>>> getTableAll() async {
    List<TableModel> list;
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
