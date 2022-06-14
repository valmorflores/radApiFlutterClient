import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../../core/constants/ktables.dart';
import '../../../../modules/clients/domain/const/clients_constants.dart';
import '../../../../modules/clients/infra/datasources/clients_datasource.dart';
import '../../../../modules/clients/infra/models/client_model.dart';
import '../../../../utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIAPIClientsDatasource implements ClientsDatasource {
  final Dio dio;
  EIAPIClientsDatasource(this.dio);

  Future<List<ClientModel>> getAll() {
    debugPrint('f1902 - ' + app_urlapi + '/clients ');
    return dio.get(app_urlapi + '/clients').then((res) async {
      //debugPrint(res.toString());
      //return res.data.map<ClientModel>(ClientModel.fromJson).toList();
      List<ClientModel> clients = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        clients.add(ClientModel.fromJson(item));
      });
      debugPrint('f1902 - Saving local clients...');
      var dbTable =
          app_selected_workspace_name + kWorkspaceTblSeparator + kTblClients;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(dbTable, jsonEncode(dados));
      debugPrint('f1902 - Table: ' + dbTable);
      debugPrint('f1902 - done');
      return clients;
    });
  }

  Future<List<ClientModel>> getById(int id) async {
    String _url = app_urlapi + '/clients/' + id.toString();
    debugPrint('f7407 - Clients [GET] url: $_url');
    return dio.get(_url).then((res) {
      List<ClientModel> clients = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        clients.add(ClientModel.fromJson(item));
      });
      return clients;
    });
  }

  @override
  Future<List<ClientModel>> searchText(String textSearch) {
    // TODO: implement searchText
    throw UnimplementedError();
  }

  @override
  Future<List<ClientModel>> updateById(ClientModel clientModel) async {
    String _url = app_urlapi + '/clients/' + clientModel.userid.toString();
    debugPrint('f7407 - Clients [PUT] url: $_url');
    return dio.put(_url, data: clientModel.toJson()).then((res) {
      List<ClientModel> clients = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        clients.add(ClientModel.fromJson(item));
      });
      return clients;
    });
  }

  @override
  Future<bool> deleteClientById(int id) {
    String _url = app_urlapi + '/clients/' + id.toString();
    debugPrint('f7407 - DELETE via $_url');
    return dio.delete(_url).then((res) {
      List<ClientModel> clients = [];
      var dados = res.data['data'];
      return true;
    });
  }

  @override
  Future<List<ClientModel>> clientAdd(ClientModel clientModel) async {
    String _url = app_urlapi + '/clients';
    debugPrint('f7407 - Clients [PUT] url: $_url');
    return dio.post(_url, data: clientModel.toJson()).then((res) {
      List<ClientModel> clients = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        clients.add(ClientModel.fromJson(item));
      });
      return clients;
    });
  }
}
