import 'package:dartz/dartz.dart';
import '../../domain/usecases/get_table_all.dart';
import '../../domain/repositories/table_repository.dart';
import '../../external/api/eiapi_table_datasource.dart';
import '../../infra/datasource/table_datasource.dart';
import '../../infra/repository/table_repository_impl.dart';
import '/modules/table/infra/models/table_model.dart';
import '/modules/update/presenter/controllers/url_controller.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TableController extends GetxController {
  UrlController urlController = Get.put(UrlController());

  RxInt count = 0.obs;
  RxString urlImage = ''.obs;

  late final tableList = <TableModel>[].obs;

  late int selectedStaffId;

  final dio = WksCustomDio.withAuthentication().instance;
  late TableDatasource datasource;
  late TableRepository tableRepository;

  late GetTableAll getTableAll;

  getTableAllData() async {
    var result = await _getTableAll();
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<TableModel> _myUrlModel = info;
      tableList.clear();
      _myUrlModel.forEach((element) {
        //selectedStaffId = element.staffid ?? 0;
        tableList.add(element);
        count++;
      });
    }
    update();
  }

  _getTableAll() async {
    debugPrint('f8004 - get table all via controller ');
    GetTableAllImpl getTableAllImpl = GetTableAllImpl(tableRepository);
    return await getTableAllImpl.call();
  }

  @override
  void onInit() {
    selectedStaffId = 0;

    // Links for data get
    datasource = EIAPITableDatasource(dio);
    tableRepository = TableRepositoryImpl(datasource);
    getTableAll = GetTableAllImpl(tableRepository);
    urlImage.value = '';
    getTableAllData();

    super.onInit();
  }
}
