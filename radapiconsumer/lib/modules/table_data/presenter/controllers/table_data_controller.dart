import 'package:dartz/dartz.dart';
import '../../domain/usecases/get_table_field_all.dart';
import '../../domain/repositories/table_data_repository.dart';
import '../../external/api/eiapi_table_data_datasource.dart';
import '../../infra/datasource/table_data_datasource.dart';
import '../../infra/models/table_data_model.dart';
import '../../infra/repository/table_field_repository_impl.dart';
import '/modules/table/infra/models/table_model.dart';
import '/modules/update/presenter/controllers/url_controller.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TableDataController extends GetxController {
  UrlController urlController = Get.put(UrlController());

  RxInt count = 0.obs;
  RxString urlImage = ''.obs;

  late final tableList = <TableDataModel>[].obs;

  late int selectedStaffId;
  late String selectedTableName;

  final dio = WksCustomDio.withAuthentication().instance;
  late TableDataDatasource datasource;
  late TableDataRepository tableFieldRepository;

  late GetTableFieldAll getTableAll;

  getTableFieldAllData(String tableName) async {
    var result = await _getTableFieldAll(tableName);
    tableList.clear();
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<TableDataModel> _myUrlModel = info;
      _myUrlModel.forEach((element) {
        //selectedStaffId = element.staffid ?? 0;
        tableList.add(element);
        count++;
      });
    }
    update();
  }

  _getTableFieldAll(String tableName) async {
    debugPrint('f8004 - get table all via controller ');
    GetTableFieldAllImpl getTableFieldAllImpl =
        GetTableFieldAllImpl(tableFieldRepository);
    return await getTableFieldAllImpl.call(tableName);
  }

  @override
  void onInit() {
    selectedStaffId = 0;

    // Links for data get
    datasource = EIAPITableDataDatasource(dio);
    tableFieldRepository = TableFieldRepositoryImpl(datasource);
    getTableAll = GetTableFieldAllImpl(tableFieldRepository);

    // onInit
    super.onInit();
  }

  // Refresh all info
  refreshAll(String tableName) {
    selectedTableName = tableName;
    getTableFieldAllData(tableName);
  }
}
