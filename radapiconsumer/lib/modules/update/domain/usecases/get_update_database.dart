import 'package:dartz/dartz.dart';
import '/modules/update/domain/entities/update_result.dart';
import '/modules/update/domain/errors/errors.dart';
import '/modules/update/domain/entities/url_result.dart';
import '/modules/update/domain/repositories/update_database_repository.dart';
import '/modules/update/domain/repositories/url_repository.dart';

mixin GetUpdateDatabaseAll {
  Future<Either<Failure, List<UpdateResult>>> call();
}

//? @Injectable(singleton: false)
class GetUpdateDatabaseAllImpl implements GetUpdateDatabaseAll {
  final UpdateDatabaseRepository repository;

  GetUpdateDatabaseAllImpl(this.repository);

  @override
  Future<Either<Failure, List<UpdateResult>>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getUpdate();
      return result.fold(
          (l) => left(l), (r) => r == null ? left(EmptyList()) : right(r));
    });
  }
}
