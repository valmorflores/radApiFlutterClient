import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';

mixin GetStaffAll {
  Future<Either<Failure, List<StaffResult>>> call();
}

//? @Injectable(singleton: false)
class GetStaffAllImpl implements GetStaffAll {
  final StaffRepository repository;

  GetStaffAllImpl(this.repository);

  @override
  Future<Either<Failure, List<StaffResult>>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getStaffAll();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
