import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/entities/person_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';
import '/modules/workspaces/domain/repositories/person_repository.dart';
import '/modules/workspaces/infra/datasources/person_datasource.dart';
import '/modules/workspaces/infra/models/person_model.dart';
import 'package:flutter/cupertino.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonDatasource datasource;

  PersonRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<PersonResult>>> getPersons(
      String searchText) async {
    List<PersonModel> list;
    try {
      list = await datasource.getPersons(searchText);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint('***[ Error ]***');
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<PersonResult>>> getAll() async {
    List<PersonModel> list;
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
  Future<Either<Failure, List<PersonResult>>> getByAlias(
      String searchText) async {
    List<PersonModel> list;
    try {
      list = await datasource.getByAlias(searchText);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<PersonResult>>> getById(int id) async {
    List<PersonModel> list;
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
  Future<Either<Failure, PersonResult>> postLogin(
      String email, String password) async {
    PersonModel list;
    try {
      list = await datasource.postLogin(email, password);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      // Error 404
      if (e.toString().indexOf('[404]') > 0) {
        debugPrint('***[ Error 404 ]***');
        return left(ErrorLoginNotFound());
        // Error 401 - Not found
      } else if (e.toString().indexOf('[401]') > 0) {
        debugPrint('***[ Error 401 ]***');
        return left(ErrorLoginFail());
        // Anothers errors
      } else {
        debugPrint(e.toString());
      }
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
