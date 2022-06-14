import 'package:dartz/dartz.dart';
import '../../../../modules/connection/domain/entities/connection_result.dart';
import '../../../../modules/connection/domain/errors/errors.dart';
import '../../../../modules/connection/domain/repositories/connection_repository.dart';

mixin GetConnectionAll {
  Future<Either<Failure, List<ConnectionResult>>> call();
}

//? @Injectable(singleton: false)
class GetConnectionAllImpl implements GetConnectionAll {
  final ConnectionRepository repository;

  GetConnectionAllImpl(this.repository);

  @override
  Future<Either<Failure, List<ConnectionResult>>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getConnectionAll();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
