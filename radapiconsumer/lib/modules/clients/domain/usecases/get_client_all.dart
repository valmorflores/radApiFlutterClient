import 'package:dartz/dartz.dart';
import '../../../../modules/clients/domain/entities/client_result.dart';
import '../../../../modules/clients/domain/errors/errors.dart';
import '../../../../modules/clients/domain/repositories/client_repository.dart';

mixin GetClientAll {
  Future<Either<Failure, List<ClientResult>>> call();
}

//? @Injectable(singleton: false)
class GetClientAllImpl implements GetClientAll {
  final ClientRepository repository;

  GetClientAllImpl(this.repository);

  @override
  Future<Either<Failure, List<ClientResult>>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getClientAll();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
