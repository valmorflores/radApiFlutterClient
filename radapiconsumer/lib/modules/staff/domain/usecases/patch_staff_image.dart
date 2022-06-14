import 'package:dartz/dartz.dart';

import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';

mixin PatchStaffImage {
  Future<Either<Failure, List<StaffResult>>> call(StaffResult staffModel);
}

class PatchStaffImageImpl implements PatchStaffImage {
  final StaffRepository repository;

  PatchStaffImageImpl(this.repository);

  @override
  Future<Either<Failure, List<StaffResult>>> call(
      StaffResult staffModel) async {
    var option = optionOf(staffModel);

    return option.fold(() => Left(InvalidSearchText()), (staffModel) async {
      var result = await repository.patchStaffImage(staffModel);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
