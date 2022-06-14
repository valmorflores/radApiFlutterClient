import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_key_result.dart';
import '/modules/staff/domain/errors/errors.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';

mixin GetMyKeys {
  Future<Either<Failure, List<StaffKeyResult>>> call(i);
}

//? @Injectable(singleton: false)
class GetMyKeysImpl implements GetMyKeys {
  final StaffRepository repository;

  GetMyKeysImpl(this.repository);

  @override
  Future<Either<Failure, List<StaffKeyResult>>> call(i) async {
    var option = optionOf(i);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getMyKeys();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
