import 'package:flutter/cupertino.dart';
import 'package:radapiconsumer/utils/wks_custom_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../../utils/globals.dart';
import '../../../table_field/infra/models/table_field_model.dart';
import '../../infra/datasource/table_data_datasource.dart';
import '../../infra/models/table_data_model.dart';

class EIAPITableDataDatasource implements TableDataDatasource {
  final Dio dio;
  EIAPITableDataDatasource(this.dio);

  @override
  Future<List<TableDataModel>> getAll(String tableName) async {
    debugPrint('f1902 - ' + app_urlapi + '/tables/fields/' + tableName);

    List<TableFieldModel> tableFields = await dataFields(tableName);
    List<TableDataModel> tableData = [];
    tableFields.forEach((element) {});
    return tableData;
  }

  Future<List<TableFieldModel>> dataFields(String tableName) async {
    return dio.get(app_urlapi + '/tables/fields/' + tableName).then((res) {
      List<TableFieldModel> tableFields = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        tableFields.add(TableFieldModel(
            id: 0,
            name: item['name'],
            type: item['type'],
            size: item['size'] == null
                ? 0
                : item['size'].toString() == ''
                    ? 0
                    : int.parse(item['size'].toString() ?? '0')));
      });
      return tableFields;
    });
  }

  /*
  @override
  Future<List<TableDataModel>> getAll(String tableName) {
    debugPrint('f1902 - ' + app_urlapi + '/tables/fields/' + tableName);
    return dio
        .get(app_urlapi + '/tables/fields/' + tableName)
        .then((res) async {
      List<TableFieldModel> tableFields = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        tableFields.add(TableFieldModel(
            id: 0,
            name: item['name'],
            type: item['type'],
            size: item['size'] == null
                ? 0
                : item['size'].toString() == ''
                    ? 0
                    : int.parse(item['size'].toString() ?? '0')));
      });
      debugPrint('f1902 - Saving local table...');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return tableFields;
    });
  }
  */
}
