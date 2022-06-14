import 'package:dartz/dartz.dart';

import '../entities/table_result.dart';
import '../errors/errors.dart';

abstract class TableRepository {
  Future<Either<Failure, List<TableResult>>> getTableAll();
}
