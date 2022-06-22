import 'package:dartz/dartz.dart';
import '../../domain/usecases/get_table_all.dart';
import '../../domain/repositories/table_data_repository.dart';
import '../../external/api/eiapi_table_data_datasource.dart';
import '../../infra/datasource/table_data_datasource.dart';
import '../../infra/models/table_data_model.dart';
import '../../infra/repository/table_data_repository_impl.dart';
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
  RxString tableName = ''.obs;

  late int selectedStaffId;
  late String selectedTableName;

  final dio = WksCustomDio.withAuthentication().instance;
  late TableDataDatasource datasource;
  late TableDataRepository tableDataRepository;

  late GetTableAll getTableAll;

  setTableName(String newTableName) {
    tableName.value = newTableName;
  }

  getTableFieldAllData(String tableName) async {
    var result = await _getTableFieldAll(tableName);
    tableList.clear();
    if (result.isRight()) {
      var info = (result as Right).value;
      final TableDataModel _myUrlModel = info;
      tableList.add(_myUrlModel);
      /*_myUrlModel.forEach((element) {
        //selectedStaffId = element.staffid ?? 0;
        tableList.add(element);
        count++;
      });
      */
    }
    update();
  }

  _getTableFieldAll(String tableName) async {
    debugPrint('f8004 - get table all via controller ');
    GetTableFieldAllImpl getTableFieldAllImpl =
        GetTableFieldAllImpl(tableDataRepository);
    return await getTableFieldAllImpl.call(tableName);
  }

  @override
  void onInit() {
    selectedStaffId = 0;

    // Links for data get
    datasource = EIAPITableDataDatasource(dio);
    tableDataRepository = TableDataRepositoryImpl(datasource);
    getTableAll = GetTableFieldAllImpl(tableDataRepository);

    // onInit
    super.onInit();
  }

  // Refresh all info
  refreshAll(String tableName) {
    selectedTableName = tableName;
    getTableFieldAllData(tableName);
  }
}
