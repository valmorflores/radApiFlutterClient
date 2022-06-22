import 'package:flutter/cupertino.dart';
import 'package:radapiconsumer/modules/table_data/domain/entities/table_record_result.dart';
import 'package:radapiconsumer/utils/wks_custom_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../../utils/globals.dart';
import '../../../table_field/infra/models/table_field_model.dart';
import '../../infra/datasource/table_data_datasource.dart';
import '../../infra/models/table_data_model.dart';
import '../../infra/models/table_field_record_model.dart';
import '../../infra/models/table_record_model.dart';

class EIAPITableDataDatasource implements TableDataDatasource {
  final Dio dio;
  EIAPITableDataDatasource(this.dio);

  @override
  Future<TableDataModel> getAll(String tableName) async {
    debugPrint('f1902 - ' + app_urlapi + '/tables/fields/' + tableName);
    int numrecord = 0;
    List<TableFieldModel> tableFields = await dataFields(tableName);
    TableDataModel tableData = TableDataModel();
    List<TableRecordModel> tableRecords = <TableRecordModel>[];
    await dio.get(app_urlapi + '/tables/data/' + tableName).then((res) {
      var dados = res.data['data'];
      dados.forEach((item) {
        ++numrecord;
        TableRecordModel oneRecord = TableRecordModel();
        tableFields.forEach((element) {
          String? fieldName = element.name;
          String? fieldData = item[element.name];
          TableFieldRecordModel oneField = TableFieldRecordModel(
              fieldName: fieldName,
              fieldData: fieldData,
              fieldRecord: numrecord);
          oneRecord.add(oneField);
        });
        tableRecords.add(oneRecord);
      });
    });
    return TableDataModel(records: tableRecords);
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
                    : int.parse(item['size']?.toString() ?? '0')));
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
