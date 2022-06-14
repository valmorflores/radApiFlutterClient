import 'package:dartz/dartz.dart';
import '/modules/contacts/domain/entities/contact_result.dart';
import '/modules/contacts/domain/errors/erros.dart';
import '/modules/contacts/domain/repositories/contacts_repository.dart';
import '/modules/contacts/infra/datasources/contact_datasource.dart';
import '/modules/contacts/infra/models/contact_model.dart';
import 'package:flutter/cupertino.dart';

class ContactRepositoryImpl implements ContactsRepository {
  final ContactDatasource datasource;

  ContactRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ContactResult>>> getUsers(
      String searchText) async {
    List<ContactModel> list;

    try {
      list = await datasource.getUsers(searchText);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<ContactResult>>> getById(int id) async {
    // TODO: implement getById
    List<ContactModel> list;

    try {
      list = await datasource.getById(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<ContactResult>>> getAll() async {
    List<ContactModel> list;
    try {
      list = await datasource.getAll();
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, bool>> deleteById(int id) async {
    bool res;
    try {
      res = await datasource.deleteById(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return res == null ? left(DatasourceResultNull()) : right(res);
  }
}
