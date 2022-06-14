import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_key_result.dart';
import '/modules/staff/domain/errors/staff_key_errors.dart';
import '/modules/staff/domain/repositories/staff_key_repository.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';

mixin GetLastKey {
  Future<Either<Failure, List<StaffKeyResult>>> call(StaffKeyResult i);
}

//? @Injectable(singleton: false)
class GetLastKeyImpl implements GetLastKey {
  final StaffKeyRepository repository;

  GetLastKeyImpl(this.repository);

  @override
  Future<Either<Failure, List<StaffKeyResult>>> call(i) async {
    var option = optionOf(i);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getLastKey(i);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
