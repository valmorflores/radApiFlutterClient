import 'package:dartz/dartz.dart';

import '../entities/table_data_result.dart';
import '../errors/errors.dart';

abstract class TableDataRepository {
  Future<Either<Failure, TableDataResult>> getTableAll(String tableName);
}
