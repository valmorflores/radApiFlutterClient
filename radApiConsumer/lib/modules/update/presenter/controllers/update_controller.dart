import 'package:dartz/dartz.dart';
import '/core/platform/network_info.dart';
import '/modules/update/domain/repositories/update_database_repository.dart';
import '/modules/update/domain/usecases/get_update_database.dart';
import '/modules/update/external/api/eiapi_update_datasource.dart';
import '/modules/update/infra/datasources/update_database_datasource.dart';
import '/modules/update/infra/models/update_model.dart';
import '/modules/update/infra/repositories/update_database_repository_impl.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UpdateController extends GetxController {
  RxList updateModelList = <UpdateModel>[].obs;
  RxInt count = 0.obs;

  late WksCustomDio dio;
  late NetworkInfo networkInfo;
  /* usecases */
  GetUpdateDatabaseAll? getUpdateDatabaseRemote;

  /* repository */
  late UpdateDatabaseRepository repositoryRemote;
  /* local and remote */
  late UpdateDatabaseDatasource remote;

  Future<void> runUpdate() async {
    debugPrint(
        'f7872 - clear updateModelList and reload URLs list from UpdateController');
    updateModelList.clear();
    var result = await getUpdateDatabaseRemote!.call();
    debugPrint('f7872 - After call?');
    if (result.isRight()) {
      var info = (result as Right).value;
      final UpdateModel _myUpdateModel = info;
      debugPrint('f7872 - This is the first link for urlList');
      updateModelList.clear();
      updateModelList.add(_myUpdateModel);
    }
    debugPrint('f7872 - done');
    ++count;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final dio = WksCustomDio.withAuthentication().instance;
    remote = EIAPIUpdateDatabaseDatasource(dio);
    repositoryRemote = UpdateDatabaseRepositoryImpl(remote);
    getUpdateDatabaseRemote = GetUpdateDatabaseAllImpl(repositoryRemote);
    debugPrint('f7872 - UpdateController() onInit() started...');
  }
}
