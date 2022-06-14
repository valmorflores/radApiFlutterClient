import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/constants/ktables.dart';
import '../../../../modules/connection/infra/models/ConnectionModel.dart';
import '../../../../modules/connection/infra/datasources/connection_datasource.dart';
import '../../../../modules/connection/domain/const/connection_constants.dart';
import '../../../../utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIDBConnectionDatasource implements ConnectionDatasource {
  EIDBConnectionDatasource();

  @override
  Future<List<ConnectionModel>> searchText(String textSearch) async {
    var listCourses;
    var list = listCourses;
    return list;
  }

  @override
  Future<List<ConnectionModel>> getAll() async {
    debugPrint('EIDB_connection_DATASOURCE_ via getAll');
    var dbTable =
        app_selected_workspace_name + kWorkspaceTblSeparator + kTblConnection;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var info = prefs.getString(dbTable);
    List<ConnectionModel> list = [];
    try {
      var result = jsonDecode(info!);
      var jsonList = result as List;
      debugPrint('f5800 - list with size => ' + jsonList.length.toString());
      jsonList.forEach((item) {
        list.add(ConnectionModel.fromJson(item));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint('f5800 - list complete');
    debugPrint('f5800 - done');
    return list;
  }

  @override
  Future<List<ConnectionModel>> updateById(
      ConnectionModel connectionModel) async {
    // TODO: implement clientAdd
    throw UnimplementedError();
  }

  @override
  Future<List<ConnectionModel>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<ConnectionModel>> connectionAdd(
      ConnectionModel connectionModel) async {
    debugPrint('EIDB_connection_DATASOURCE_ connectionAdd');
    var dbTable =
        app_selected_workspace_name + kWorkspaceTblSeparator + kTblConnection;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonList = [];
    List<ConnectionModel> list = [];
    try {
      list = await getAll();
    } catch (e) {
      list = <ConnectionModel>[];
    }
    list.add(connectionModel);
    debugPrint('f5800 - list with size => ' + list.length.toString());
    prefs.setString(dbTable, jsonEncode(list));
    return list;
  }

  @override
  Future<bool> deleteConnectionById(int id) {
    // TODO: implement deleteConnectionById
    throw UnimplementedError();
  }
}
