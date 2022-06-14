import 'package:dartz/dartz.dart';
import 'package:radapiconsumer/modules/user/domain/usecases/post_user_login.dart';
import '../../domain/repositories/user_login_repository.dart';

import '../../external/api/eiapi_user_login_datasource.dart';
import '../../infra/datasources/user_login_datasource.dart';
import '../../infra/models/user_login_model.dart';
import '../../infra/repositories/user_login_repository_impl.dart';

import '/modules/update/presenter/controllers/url_controller.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UrlController urlController = Get.put(UrlController());

  RxInt count = 0.obs;
  RxString urlImage = ''.obs;

  late final staffList = <UserLoginModel>[].obs;

  late int selectedStaffId;

  final dio = WksCustomDio.withAuthentication().instance;
  late UserLoginDatasource datasource;
  late UserLoginRepository loginRepository;

  late PostUserLogin postLogin;

  userPostLogin({required String email, required String password}) async {
    var result = await _postUserLogin(email, password);
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<UserLoginModel> _myUrlModel = info;
      _myUrlModel.forEach((element) {
        //selectedStaffId = element.staffid ?? 0;
        count++;
      });
    }
    update();
  }

  _postUserLogin(String _email, _password) async {
    debugPrint('f8004 - Patch firstname: $_email, lastname: $_password ');
    UserLoginImpl _userLoginImpl = UserLoginImpl(loginRepository);
    return await _userLoginImpl.call(_email, _password);
  }

  @override
  void onInit() {
    selectedStaffId = 0;

    // Links for data get
    datasource = EIAPIUserLoginDatasource(dio);
    loginRepository = UserLoginRepositoryImpl(datasource);
    postLogin = UserLoginImpl(loginRepository);
    urlImage.value = '';

    super.onInit();
  }
}
