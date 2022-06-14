import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/user_login_result.dart';
import '../../domain/errors/errors.dart';
import '../../domain/repositories/user_login_repository.dart';
import '../datasources/user_login_datasource.dart';
import '../models/user_login_model.dart';

class UserLoginRepositoryImpl implements UserLoginRepository {
  final UserLoginDatasource datasource;

  UserLoginRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<UserLoginResult>>> postLogin(
      String email, String password) async {
    List<UserLoginModel> list;
    try {
      list = await datasource.postLogin(email, password);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
