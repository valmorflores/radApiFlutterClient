import 'package:dartz/dartz.dart';
import '../../../../modules/connection/domain/entities/connection_result.dart';
import '../../../../modules/connection/domain/errors/errors.dart';
import '../../../../modules/connection/domain/repositories/connection_repository.dart';

mixin DeleteConnectionById {
  Future<Either<Failure, bool>> call(int id);
}

class DeleteConnectionByIdImpl implements DeleteConnectionById {
  final ConnectionRepository repository;
  DeleteConnectionByIdImpl(this.repository);
  @override
  Future<Either<Failure, bool>> call(int id) async {
    var option = optionOf(id);
    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.deleteConnectionById(id);
      return result.fold(
          (l) => left(l), (r) => r == null ? left(EmptyList()) : right(r));
    });
  }
}
