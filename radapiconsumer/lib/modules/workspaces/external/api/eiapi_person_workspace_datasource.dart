import 'dart:convert';

import 'package:dio/dio.dart';
import '/modules/workspaces/infra/models/person_workspace_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/modules/workspaces/infra/datasources/person_workspace_datasource.dart';
import '/utils/globals.dart';

class EIAPIPersonWorkspaceDatasource implements PersonWorkspaceDatasource {
  final Dio dio;

  EIAPIPersonWorkspaceDatasource(this.dio);

  @override
  Future<List<PersonWorkspaceModel>> getByPersonId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = mgr_urlapi + "/person/" + id.toString() + "/workspaces";
    var params = {'personid': id};
    debugPrint('Running personWorkspace - getByPersonId from: ' + url);
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      var jsonList = result.data['data'];
      //var token = jsonList['token'];
      //await prefs.setString('token', token);
      int i = 0;
      List<PersonWorkspaceModel> workspaces = [];
      debugPrint(jsonList.toString());
      jsonList.forEach((item) {
        var itemId = item['id'];
        debugPrint('...inserindo item {$itemId}');
        workspaces.add(PersonWorkspaceModel(
            id: item['id'],
            name: item['name'],
            workspaceId: item['id'],
            workspaceKeyValue: item['workspacekeyvalue']));
      });
      return workspaces;
    } else {
      throw Exception();
    }
  }
}
