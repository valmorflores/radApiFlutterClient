import 'package:dartz/dartz.dart';
import '../../../../modules/connection/domain/entities/connection_result.dart';
import '../../../../modules/connection/domain/errors/errors.dart';
import '../../../../modules/connection/domain/repositories/connection_repository.dart';
import '../repositories/connection_repository.dart';

mixin GetConnetionById {
  Future<Either<Failure, List<ConnectionResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetConnetionByIdImpl implements GetConnetionById {
  final ConnectionRepository repository;

  GetConnetionByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<ConnectionResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getConnectionById(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
