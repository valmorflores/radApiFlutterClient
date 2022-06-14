import 'dart:convert';

import '../../../../modules/clients/infra/models/client_model.dart';
import '../../../../utils/custom_dio.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';

class DirectClientRepository {
  Future<List<ClientModel>> getAll() {
    var dio = WksCustomDio.withAuthentication().instance;
    debugPrint('GET ' + app_urlapi + '/clients ');
    return dio.get(app_urlapi + '/clients').then((res) {
      debugPrint(res.toString());
      //return res.data.map<ClientModel>(ClientModel.fromJson).toList();
      List<ClientModel> clients = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        clients.add(ClientModel.fromJson(item));
      });
      return clients;
    });
  }

  Future<ClientModel> getById(int id) {
    debugPrint('============================');
    var dio = WksCustomDio.withAuthentication().instance;
    debugPrint('GET ' + app_urlapi + '/clients/:id');
    return dio.get(app_urlapi + '/clients/' + id.toString()).then((res) {
      ClientModel client = ClientModel();
      var dados = res.data['data'];
      dados.forEach((item) {
        client = ClientModel.fromJson(item);
      });
      return client;
    });
  }
}
