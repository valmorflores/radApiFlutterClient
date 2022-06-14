import 'package:dartz/dartz.dart';
import '/modules/contacts/domain/entities/contact_result.dart';
import '/modules/contacts/domain/errors/erros.dart';
import '/modules/contacts/domain/repositories/contacts_repository.dart';

mixin GetById {
  Future<Either<Failure, List<ContactResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetByIdImpl implements GetById {
  final ContactsRepository repository;

  GetByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<ContactResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getById(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
