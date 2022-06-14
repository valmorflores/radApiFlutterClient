import 'package:dartz/dartz.dart';
import '/modules/contacts/domain/entities/contact_result.dart';
import '/modules/contacts/domain/errors/erros.dart';
import '/modules/contacts/domain/repositories/contacts_repository.dart';

mixin GetUsers {
  Future<Either<Failure, List<ContactResult>>> call(String text);
}

//? @Injectable(singleton: false)
class GetUsersImpl implements GetUsers {
  final ContactsRepository repository;

  GetUsersImpl(this.repository);

  @override
  Future<Either<Failure, List<ContactResult>>> call(String text) async {
    var option = optionOf(text);

    return option.fold(() => Left(InvalidSearchText()), (text) async {
      var result = await repository.getUsers(text);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
