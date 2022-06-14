import 'package:dartz/dartz.dart';
import '../../../../modules/clients/domain/entities/client_result.dart';
import '../../../../modules/clients/domain/errors/errors.dart';
import '../../../../modules/clients/domain/repositories/client_repository.dart';

mixin GetClientById {
  Future<Either<Failure, List<ClientResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetClientByIdImpl implements GetClientById {
  final ClientRepository repository;

  GetClientByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<ClientResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getClientById(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
