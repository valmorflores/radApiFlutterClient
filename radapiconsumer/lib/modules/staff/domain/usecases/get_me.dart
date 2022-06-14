import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';

mixin GetMe {
  Future<Either<Failure, List<StaffResult>>> call(i);
}

//? @Injectable(singleton: false)
class GetMeImpl implements GetMe {
  final StaffRepository repository;

  GetMeImpl(this.repository);

  @override
  Future<Either<Failure, List<StaffResult>>> call(i) async {
    var option = optionOf(i);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getMe();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
