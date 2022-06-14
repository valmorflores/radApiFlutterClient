import 'package:dartz/dartz.dart';
import '../../../../modules/connection/domain/entities/connection_result.dart';
import '../../../../modules/connection/domain/errors/errors.dart';
import '../../../../modules/connection/domain/repositories/connection_repository.dart';

mixin UpdateConnection {
  Future<Either<Failure, List<ConnectionResult>>> call(
      ConnectionResult ConnectionResult);
}

class UpdateConnectionImpl implements UpdateConnection {
  final ConnectionRepository repository;

  UpdateConnectionImpl(this.repository);

  @override
  Future<Either<Failure, List<ConnectionResult>>> call(ConnectionResult) async {
    var option = optionOf(ConnectionResult);
    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.updateConnection(ConnectionResult);
      return result.fold(
          (l) => left(l), (r) => r == null ? left(EmptyList()) : right(r));
    });
  }
}
