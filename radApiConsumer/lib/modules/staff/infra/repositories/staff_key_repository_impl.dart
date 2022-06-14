import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_key_result.dart';
import '/modules/staff/domain/errors/staff_key_errors.dart';
import '/modules/staff/domain/repositories/staff_key_repository.dart';
import '/modules/staff/infra/datasources/staff_key_datasource.dart';
import '/modules/staff/infra/models/staff_key_model.dart';
import 'package:flutter/cupertino.dart';

class StaffKeyRepositoryImpl implements StaffKeyRepository {
  final StaffKeyDatasource datasource;

  StaffKeyRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<StaffKeyModel>>> getMy() async {
    List<StaffKeyModel> list;
    try {
      list = await datasource.getMy(0);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<StaffKeyModel>>> addKey(
      StaffKeyResult staffKeyModel) async {
    List<StaffKeyModel> list;
    try {
      list = await datasource.addKey(staffKeyModel as StaffKeyModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<StaffKeyModel>>> getLastKey(
      StaffKeyResult staffKeyModel) async {
    List<StaffKeyModel> list;
    try {
      list = await datasource.getLastKey(staffKeyModel as StaffKeyModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<StaffKeyModel>>> patchStaffKey(
      StaffKeyResult staffKeyModel) async {
    List<StaffKeyModel> list;
    try {
      list = await datasource.patchStaffKey(staffKeyModel as StaffKeyModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
