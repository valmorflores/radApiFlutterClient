import 'package:dartz/dartz.dart';
import '../../../../modules/connection/domain/entities/connection_result.dart';
import '../../../../modules/connection/domain/errors/errors.dart';
import '../../../../modules/connection/domain/repositories/connection_repository.dart';
import '../entities/connection_result.dart';

mixin AddConnection {
  Future<Either<Failure, List<ConnectionResult>>> call(ConnectionResult client);
}

//? @Injectable(singleton: false)
class AddConnectionImpl implements AddConnection {
  final ConnectionRepository repository;

  AddConnectionImpl(this.repository);

  @override
  Future<Either<Failure, List<ConnectionResult>>> call(ConnectionResult client) async {
    var option = optionOf(client);

    return option.fold(() => Left(InvalidSearchText()), (client) async {
      var result = await repository.addConnection(client);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
