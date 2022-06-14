import 'package:dio/dio.dart';
import '/modules/update/infra/datasources/update_database_datasource.dart';
import '/modules/update/infra/models/update_model.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';

class EIAPIUpdateDatabaseDatasource implements UpdateDatabaseDatasource {
  final Dio dio;

  EIAPIUpdateDatabaseDatasource(this.dio);

  @override
  Future<List<UpdateModel>> getUpdate() async {
    List<UpdateModel> updateModelList = [];
    debugPrint('f7004 - EIAPI_UPDATE_ via getAll');
    final String _url = app_urlapi + "/update";
    debugPrint('f7004 - url (0): $_url');
    var result = await this.dio.get(_url);
    if (result.statusCode == 200) {
      var data = result.data['data'];
      for (var item in data) {
        updateModelList.add(item as UpdateModel);
      }
      return updateModelList;
    } else {
      throw Exception();
    }
  }
}
