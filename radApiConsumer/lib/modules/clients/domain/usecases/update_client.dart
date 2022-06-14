import 'package:dartz/dartz.dart';
import '../../../../modules/clients/domain/entities/client_result.dart';
import '../../../../modules/clients/domain/errors/errors.dart';
import '../../../../modules/clients/domain/repositories/client_repository.dart';

mixin UpdateClient {
  Future<Either<Failure, List<ClientResult>>> call(ClientResult clientResult);
}

class UpdateClientImpl implements UpdateClient {
  final ClientRepository repository;

  UpdateClientImpl(this.repository);

  @override
  Future<Either<Failure, List<ClientResult>>> call(clientResult) async {
    var option = optionOf(clientResult);
    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.updateClient(clientResult);
      return result.fold(
          (l) => left(l), (r) => r == null ? left(EmptyList()) : right(r));
    });
  }
}
