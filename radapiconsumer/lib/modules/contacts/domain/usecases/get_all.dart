import 'package:dartz/dartz.dart';
import '/modules/contacts/domain/entities/contact_result.dart';
import '/modules/contacts/domain/errors/erros.dart';
import '/modules/contacts/domain/repositories/contacts_repository.dart';

mixin GetAll {
  Future<Either<Failure, List<ContactResult>>> call();
}

//? @Injectable(singleton: false)
class GetAllImpl implements GetAll {
  final ContactsRepository repository;

  GetAllImpl(this.repository);

  @override
  Future<Either<Failure, List<ContactResult>>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getAll();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
