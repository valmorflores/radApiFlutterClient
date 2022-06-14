import 'package:dartz/dartz.dart';
import '/modules/profile/domain/entities/profile_result.dart';
import '/modules/profile/domain/errors/erros.dart';
import '/modules/profile/domain/repositories/profile_repository.dart';

mixin GetDetailsById {
  Future<Either<Failure, List<ProfileResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetDetailsByIdImpl implements GetDetailsById {
  final ProfileRepository repository;

  GetDetailsByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<ProfileResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getDetailsById(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
