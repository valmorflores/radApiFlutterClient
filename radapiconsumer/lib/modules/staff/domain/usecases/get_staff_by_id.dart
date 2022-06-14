import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';

mixin GetStaffById {
  Future<Either<Failure, List<StaffResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetStaffByIdImpl implements GetStaffById {
  final StaffRepository repository;

  GetStaffByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<StaffResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getStaffById(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
