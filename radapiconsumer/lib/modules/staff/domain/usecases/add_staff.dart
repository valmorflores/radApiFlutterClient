import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';

mixin AddStaff {
  Future<Either<Failure, List<StaffResult>>> call(StaffResult staff);
}

class AddStaffImpl implements AddStaff {
  final StaffRepository repository;

  AddStaffImpl(this.repository);

  @override
  Future<Either<Failure, List<StaffResult>>> call(StaffResult staff) async {
    var option = optionOf(staff);

    return option.fold(() => Left(InvalidSearchText()), (staff) async {
      var result = await repository.addStaff(staff);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
