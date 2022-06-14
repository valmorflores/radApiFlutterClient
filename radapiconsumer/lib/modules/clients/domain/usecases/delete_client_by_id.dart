import 'package:dartz/dartz.dart';
import '../../../../modules/clients/domain/entities/client_result.dart';
import '../../../../modules/clients/domain/errors/errors.dart';
import '../../../../modules/clients/domain/repositories/client_repository.dart';

mixin DeleteClientById {
  Future<Either<Failure, bool>> call(int id);
}

class DeleteClientByIdImpl implements DeleteClientById {
  final ClientRepository repository;
  DeleteClientByIdImpl(this.repository);
  @override
  Future<Either<Failure, bool>> call(int id) async {
    var option = optionOf(id);
    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.deleteClientById(id);
      return result.fold(
          (l) => left(l), (r) => r == null ? left(EmptyList()) : right(r));
    });
  }
}
