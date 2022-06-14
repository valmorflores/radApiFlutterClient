import 'package:dartz/dartz.dart';
import '../../../../modules/profile/domain/errors/erros.dart';
import '../../../../modules/profile/domain/entities/profile_result.dart';
import '../../../../modules/profile/domain/repositories/profile_repository.dart';
import '../../../../modules/profile/infra/datasources/profile_datasource.dart';
import '../../../../modules/profile/infra/models/profile_model.dart';
import 'package:flutter/cupertino.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ProfileResult>>> getUsers(
      String searchText) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProfileResult>>> getDetailsById(int id) async {
    List<ProfileModel> list;

    try {
      list = await datasource.getDetailById(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<ProfileResult>>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> getIdByEmail(String email) async {
    int id;

    try {
      id = await datasource.getIdByEmail(email);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return id == 0 ? left(DatasourceResultNull()) : right(id);
  }
}
