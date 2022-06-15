import 'package:dartz/dartz.dart';

import '../entities/table_field_result.dart';
import '../errors/errors.dart';

abstract class TableFieldRepository {
  Future<Either<Failure, List<TableFieldResult>>> getTableFieldAll(
      String tableName);
}
