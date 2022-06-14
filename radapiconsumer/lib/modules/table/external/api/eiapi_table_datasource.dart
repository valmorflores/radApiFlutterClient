import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../../utils/globals.dart';
import '../../infra/datasource/table_datasource.dart';
import '../../infra/models/table_model.dart';

class EIAPITableDatasource implements TableDatasource {
  final Dio dio;
  EIAPITableDatasource(this.dio);

  @override
  Future<List<TableModel>> getAll() {
    debugPrint('f1902 - ' + app_urlapi + '/tables ');
    return dio.get(app_urlapi + '/tables').then((res) async {
      List<TableModel> table = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        table.add(TableModel.fromJson(item));
      });
      debugPrint('f1902 - Saving local table...');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return table;
    });
  }
}
