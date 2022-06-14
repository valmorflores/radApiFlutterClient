import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_key_result.dart';
import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';
import '/modules/staff/infra/datasources/staff_datasource.dart';
import '/modules/staff/infra/models/staff_key_model.dart';
import '/modules/staff/infra/models/staff_model.dart';
import 'package:flutter/cupertino.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffDatasource datasource;

  StaffRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<StaffResult>>> getStaffAll() async {
    // TODO: implement getById
    List<StaffModel> list;

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
  Future<Either<Failure, List<StaffResult>>> updateById(
      StaffResult clientResult) async {
    List<StaffModel> list;
    try {
      list = await datasource.updateById(clientResult as StaffModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<StaffResult>>> getStaffById(int id) async {
    List<StaffModel> list;
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
  Future<Either<Failure, List<StaffResult>>> getMe() async {
    List<StaffModel> list;
    try {
      list = await datasource.getMe();
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<StaffKeyResult>>> getMyKeys() {
    // TODO: implement getMyKeys
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<StaffModel>>> addStaff(StaffResult staff) async {
    List<StaffModel> list;
    try {
      list = await datasource.addStaff(staff as StaffModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<StaffKeyResult>>> addKey(
      StaffKeyResult staffkey) {
    // TODO: implement addKey
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<StaffResult>>> patchStaffImage(
      StaffResult staff) async {
    List<StaffModel> list;
    try {
      list = await datasource.patchStaffImage(staff as StaffModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<StaffResult>>> patchStaffName(
      StaffResult staff) async {
    List<StaffModel> list;
    try {
      list = await datasource.patchStaffName(staff as StaffModel);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
