import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../../core/constants/ktables.dart';
import '../../../../modules/clients/infra/datasources/clients_datasource.dart';
import '../../../../modules/clients/infra/models/client_model.dart';
import '../../../../modules/clients/domain/const/clients_constants.dart';

import '../../../../utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIDBClientsDatasource implements ClientsDatasource {
  EIDBClientsDatasource();

  @override
  Future<List<ClientModel>> searchText(String textSearch) async {
    var listCourses;
    var list = listCourses;
    return list;
  }

  @override
  Future<List<ClientModel>> getAll() async {
    debugPrint('EIDB_CLIENTS_DATASOURCE_ via getAll');
    var dbTable =
        app_selected_workspace_name + kWorkspaceTblSeparator + kTblClients;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var info = prefs.getString(dbTable);
    var result = jsonDecode(info!);
    var jsonList = result as List;
    List<ClientModel> list = [];
    debugPrint('f5800 - list with size => ' + jsonList.length.toString());
    jsonList.forEach((item) {
      list.add(ClientModel.fromJson(item));
    });
    debugPrint('f5800 - list complete');
    debugPrint('f5800 - done');
    return list;
  }

  @override
  Future<List<ClientModel>> updateById(ClientModel clientModel) async {
    // TODO: implement clientAdd
    throw UnimplementedError();
  }

  @override
  Future<List<ClientModel>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteClientById(int id) {
    // TODO: implement deleteClientById
    throw UnimplementedError();
  }

  @override
  Future<List<ClientModel>> clientAdd(ClientModel client) {
    // TODO: implement clientAdd
    throw UnimplementedError();
  }
}
