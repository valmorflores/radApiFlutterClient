import 'package:dartz/dartz.dart';
import '../../../../modules/clients/domain/entities/client_result.dart';
import '../../../../modules/clients/domain/errors/errors.dart';
import '../../../../modules/clients/domain/repositories/client_repository.dart';

mixin AddClient {
  Future<Either<Failure, List<ClientResult>>> call(ClientResult client);
}

//? @Injectable(singleton: false)
class AddClientImpl implements AddClient {
  final ClientRepository repository;

  AddClientImpl(this.repository);

  @override
  Future<Either<Failure, List<ClientResult>>> call(ClientResult client) async {
    var option = optionOf(client);

    return option.fold(() => Left(InvalidSearchText()), (client) async {
      var result = await repository.addClient(client);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
