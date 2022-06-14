import 'package:dartz/dartz.dart';
import '/core/platform/network_info.dart';
import '/modules/update/domain/repositories/url_repository.dart';
import '/modules/update/domain/usecases/get_url_all.dart';
import '/modules/update/external/api/eiapi_url_datasource.dart';
import '/modules/update/infra/datasources/url_datasource.dart';
import '/modules/update/infra/models/url_model.dart';
import '/modules/update/infra/repositories/url_repository_impl.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UrlController extends GetxController {
  RxList urlModelList = <UrlModel>[].obs;
  RxInt count = 0.obs;

  late WksCustomDio dio;
  late NetworkInfo networkInfo;
  /* usecases */
  GetUrlAll? getUrlLocal;
  GetUrlAll? getUrlRemote;
  /* repository */
  late UrlRepository repositoryRemote;
  late UrlRepository repositoryLocal;
  /* local and remote */
  late UrlDatasource local;
  late UrlDatasource remote;

  Future<void> loadUrls() async {
    debugPrint(
        'f7872 - clear urlModelList and reload URLs list from UrlController');
    urlModelList.clear();
    var result = await getUrlRemote!.call();
    debugPrint('f7872 - After call?');
    if (result.isRight()) {
      var info = (result as Right).value;
      final UrlModel _myUrlModel = info;
      debugPrint('f7872 - This is the first link for urlList');
      debugPrint('f7872 - ${_myUrlModel.activityUpload}');
      urlModelList.clear();
      urlModelList.add(_myUrlModel);
    }
    debugPrint('f7872 - done');
    ++count;
    update();
  }

  UrlModel? getUrls() {
    ++count;
    if (urlModelList.length > 0) {
      return urlModelList[0];
    } else {
      return null;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final dio = WksCustomDio.withAuthentication().instance;
    remote = EIAPIUrlDatasource(dio);
    repositoryRemote = UrlRepositoryImpl(remote);
    getUrlRemote = GetUrlAllImpl(repositoryRemote);
    debugPrint('f7872 - UrlController() onInit() started...');
  }
}
