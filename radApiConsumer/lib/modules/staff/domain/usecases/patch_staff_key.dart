import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_key_result.dart';
import '/modules/staff/domain/errors/staff_key_errors.dart';
import '/modules/staff/domain/repositories/staff_key_repository.dart';

mixin PatchStaffKey {
  Future<Either<Failure, List<StaffKeyResult>>> call(
      StaffKeyResult staffKeyModel);
}

class PatchStaffKeyImpl implements PatchStaffKey {
  final StaffKeyRepository repository;

  PatchStaffKeyImpl(this.repository);

  @override
  Future<Either<Failure, List<StaffKeyResult>>> call(
      StaffKeyResult staffKeyModel) async {
    var option = optionOf(staffKeyModel);

    return option.fold(() => Left(InvalidSearchText()), (staffKeyModel) async {
      var result = await repository.patchStaffKey(staffKeyModel);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
