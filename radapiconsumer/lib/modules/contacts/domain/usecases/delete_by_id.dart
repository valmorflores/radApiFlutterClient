import 'package:dartz/dartz.dart';
import '/modules/contacts/domain/errors/erros.dart';
import '/modules/contacts/domain/repositories/contacts_repository.dart';

mixin DeleteById {
  Future<Either<Failure, bool>> call(int id);
}

//? @Injectable(singleton: false)
class DeleteByIdImpl implements DeleteById {
  final ContactsRepository repository;

  DeleteByIdImpl(this.repository);

  @override
  Future<Either<Failure, bool>> call(int id) async {
    var option = optionOf(id);
    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.deleteById(id);
      return result.fold(
          (l) => left(l), (r) => r ? left(EmptyList()) : right(r));
    });
  }
}
