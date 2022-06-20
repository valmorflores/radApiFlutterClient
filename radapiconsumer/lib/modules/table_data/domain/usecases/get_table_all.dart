import 'package:dartz/dartz.dart';
import '../entities/table_data_result.dart';
import '../errors/errors.dart';

import '../repositories/table_data_repository.dart';

mixin GetTableAll {
  Future<Either<Failure, TableDataResult>> call(String tableName);
}

//? @Injectable(singleton: false)
class GetTableFieldAllImpl implements GetTableAll {
  final TableDataRepository repository;

  GetTableFieldAllImpl(this.repository);

  @override
  Future<Either<Failure, TableDataResult>> call(String tableName) async {
    var option = optionOf(tableName);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getTableAll(tableName);
      return result.fold(
          (l) => left(l), (r) => r == null ? left(NoRecordsFound()) : right(r));
    });
  }
}
