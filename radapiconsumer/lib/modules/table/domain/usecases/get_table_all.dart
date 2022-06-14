import 'package:dartz/dartz.dart';
import '../entities/table_result.dart';
import '../errors/errors.dart';

import '../repositories/table_repository.dart';

mixin GetTableAll {
  Future<Either<Failure, List<TableResult>>> call();
}

//? @Injectable(singleton: false)
class GetTableAllImpl implements GetTableAll {
  final TableRepository repository;

  GetTableAllImpl(this.repository);

  @override
  Future<Either<Failure, List<TableResult>>> call() async {
    var option = optionOf(1);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getTableAll();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
