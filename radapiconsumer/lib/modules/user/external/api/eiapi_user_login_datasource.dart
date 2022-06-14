import 'package:dio/dio.dart';
import '../../infra/datasources/user_login_datasource.dart';
import '../../infra/models/user_login_model.dart';
import '/modules/staff/infra/models/staff_model.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';

class EIAPIUserLoginDatasource implements UserLoginDatasource {
  final Dio dio;
  EIAPIUserLoginDatasource(this.dio);

  @override
  Future<List<UserLoginModel>> postLogin(String email, String password) async {
    debugPrint('f1252 - User Login [post]' + app_urlapi + '/user/login');
    List<UserLoginModel> staffs = await dio
        .post(app_urlapi +
            '/user/login' +
            '?' +
            'email=' +
            email +
            '&password=' +
            password)
        .then((res) {
      debugPrint(res.data.toString());
      debugPrint(res.data['token'].toString());
      List<UserLoginModel> staffs = [];
      var dados = res.data['data'];
      debugPrint('f1252 - ' + dados.toString());
      staffs.add(UserLoginModel.fromJson(dados));
      debugPrint('f1252 - done');
      return staffs;
    });
    return staffs;
  }
}
