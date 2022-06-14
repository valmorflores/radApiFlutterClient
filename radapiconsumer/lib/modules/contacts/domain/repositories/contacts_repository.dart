import 'package:dartz/dartz.dart';
import '../../../../modules/contacts/domain/entities/contact_result.dart';
import '../../../../modules/contacts/domain/errors/erros.dart';

abstract class ContactsRepository {
  Future<Either<Failure, List<ContactResult>>> getUsers(String searchText);
  Future<Either<Failure, List<ContactResult>>> getById(int id);
  Future<Either<Failure, List<ContactResult>>> getAll();
  Future<Either<Failure, bool>> deleteById(int id);
}
