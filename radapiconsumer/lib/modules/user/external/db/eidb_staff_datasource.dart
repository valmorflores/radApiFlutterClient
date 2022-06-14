import 'dart:convert';

import '/core/constants/ktables.dart';
import '/modules/staff/domain/const/staff_constants.dart';
import '/modules/staff/infra/datasources/staff_datasource.dart';
import '/modules/staff/infra/models/staff_model.dart';

import '/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIDBStaffDatasource implements StaffDatasource {
  EIDBStaffDatasource();

  @override
  Future<List<StaffModel>> searchText(String textSearch) async {
    var listCourses;
    var list = listCourses;
    return list;
  }

  @override
  Future<List<StaffModel>> getAll() async {
    debugPrint('EIDB_STAFF_DATASOURCE_ via getAll');
    var dbTable =
        app_selected_workspace_name + kWorkspaceTblSeparator + kTblStaff;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var info = prefs.getString(dbTable);
    var result = jsonDecode(info!);
    var jsonList = result as List;
    List<StaffModel> list = [];
    debugPrint('f5800 - list with size => ' + jsonList.length.toString());
    jsonList.forEach((item) {
      list.add(StaffModel.fromJson(item));
    });
    debugPrint('f5800 - list complete');
    debugPrint('f5800 - done');
    return list;
  }

  @override
  Future<List<StaffModel>> updateById(StaffModel StaffModel) async {
    // TODO: implement clientAdd
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> clientAdd(String name) {
    // TODO: implement clientAdd
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> staffAdd(String name) {
    // TODO: implement staffAdd
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> addStaff(StaffModel staff) {
    // TODO: implement addStaff
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> getMe() {
    // TODO: implement getMe
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> patchStaffImage(StaffModel staffModel) {
    // TODO: implement patchStaffImage
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> patchStaffName(StaffModel staffModel) {
    // TODO: implement patchStaffName
    throw UnimplementedError();
  }
}
