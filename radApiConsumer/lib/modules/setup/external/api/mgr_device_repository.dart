import '../../../../modules/setup/infra/models/device_model.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/mgr_custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MgrDeviceRepository {
  // To do request install for actual device
  Future<DeviceModel> install(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DeviceModel device = DeviceModel();
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/device/install";
    var dataInstall = {'email': email};
    await dio.post(url, data: dataInstall).then((res) async {
      debugPrint(res.toString());
      var dados = res.data['data'];
      debugPrint('-json-');
      debugPrint(dados);
      device.alias = dados['device_id'];
      device.id = dados['id'].toString();
      device.email = dados['email'];
/*
      "data":{"device_id":"2021~valmorflores@gmail.com72ee3e31643eb45b7ce35f52189b5b55",
      "email":"valmorflores@gmail.com",
      "id":17},"code":401,"message":"E-mail already exists"}
*/
    });
    debugPrint(device.toString());
    return device;
  }

  Future<bool> getConfirmationViaEmail(DeviceModel device) async {
    if (device.alias == '') {
      debugPrint('Empty alias...');
      return false;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/device/sendconfirmation/email";
    debugPrint('alias-----------------');
    debugPrint(device.alias);
    debugPrint('Address (url) => ${url}');
    debugPrint('alias:end-----------------');
    var dataInstall = {'device_id': device.alias, 'id': 0};
    return dio.post(url, data: dataInstall).then((res) async {
      debugPrint(res.toString());
      if (res.data['data']['retorno'] == 'Sucesso') {
        debugPrint('-> Email send success----');
        return true;
      } else {
        debugPrint('-> Email send fail----');
        return false;
      }
    });
    //debugPrint(device.toString());
    //return true; //device;
  }

  Future<bool> sendConfirmationCode(DeviceModel device) async {
    if (device.alias == '') {
      debugPrint('Empty alias...');
      return false;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/device/confirm/1/" + device.code;
    debugPrint('alias-----------------');
    debugPrint(device.alias);
    debugPrint('alias:end-----------------');
    var dataInstall = {'device_id': device.alias, 'id': 0, 'code': device.code};
    return dio.post(url, data: dataInstall).then((res) async {
      debugPrint(res.toString());
      if (res.data['data']['code'] == 200) {
        debugPrint('-> Email confirmation success----');
        return true;
      } else {
        debugPrint('-> Email confirmation fail----');
        return false;
      }
    });
    //debugPrint(device.toString());
    //return true; //device;
  }

  Future<String> createKey(DeviceModel device) async {
    if (device.alias == '') {
      debugPrint('f8852 -> Empty device.alias...');
      return '';
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + '/device/key/create';
    var dataInstall = {
      'device_id': device.alias,
      'id': 0,
      'workspace': app_workspace_name
    };
    return dio.post(url, data: dataInstall).then((res) async {
      var resposta = res.data['data'];
      if (res.statusCode == 200) {
        debugPrint('f8852 -> Key generated with sucess...');
        return resposta[0]['key'].toString();
      } else {
        debugPrint('f8852 -> Key generated fail!');
        return '';
      }
    });
  }
}
