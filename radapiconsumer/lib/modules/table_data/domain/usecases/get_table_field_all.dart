import 'package:dartz/dartz.dart';
import '../entities/table_data_result.dart';
import '../errors/errors.dart';

import '../repositories/table_data_repository.dart';

mixin GetTableFieldAll {
  Future<Either<Failure, List<TableDataResult>>> call(String tableName);
}

//? @Injectable(singleton: false)
class GetTableFieldAllImpl implements GetTableFieldAll {
  final TableDataRepository repository;

  GetTableFieldAllImpl(this.repository);

  @override
  Future<Either<Failure, List<TableDataResult>>> call(String tableName) async {
    var option = optionOf(tableName);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getTableFieldAll(tableName);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
