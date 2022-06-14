import 'package:dartz/dartz.dart';
import '/modules/keys/domain/entities/key_result.dart';
import '/modules/keys/domain/errors/errors.dart';
import '/modules/keys/domain/repositories/key_repository.dart';

mixin GetById {
  Future<Either<Failure, List<KeyResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetByIdImpl implements GetById {
  final KeyRepository repository;

  GetByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<KeyResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getById(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
