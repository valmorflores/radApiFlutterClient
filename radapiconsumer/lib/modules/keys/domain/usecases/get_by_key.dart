import 'package:dartz/dartz.dart';
import '/modules/keys/domain/entities/key_result.dart';
import '/modules/keys/domain/errors/errors.dart';
import '/modules/keys/domain/repositories/key_repository.dart';

mixin GetByKey {
  Future<Either<Failure, List<KeyResult>>> call(String key);
}

//? @Injectable(singleton: false)
class GetByKeyImpl implements GetByKey {
  final KeyRepository repository;

  GetByKeyImpl(this.repository);

  @override
  Future<Either<Failure, List<KeyResult>>> call(String key) async {
    var option = optionOf(key);

    return option.fold(() => Left(InvalidSearchText()), (key) async {
      var result = await repository.getByKey(key);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
