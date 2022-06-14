import 'package:dio/dio.dart';
import '../../domain/errors/errors.dart';
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
    List<UserLoginModel> staffs = <UserLoginModel>[];
    debugPrint('f1252 - User Login [post]' + app_urlapi + '/user/login');
    try {
      staffs = await dio
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

        var dados = res.data['data'];
        debugPrint('f1252 - ' + dados.toString());
        int staffId = 0;
        String token = res.data['token'] ?? '';
        staffId = int.parse(dados[0]['ID'] ?? '0');
        List<UserLoginModel> staffs = <UserLoginModel>[];
        staffs
            .add(UserLoginModel(active: true, staffId: staffId, token: token));
        debugPrint('f1252 - done');
        return staffs;
      });
      return staffs;
    } on DioError catch (e) {
      if (e.toString().indexOf('[404]') > 0) {
        debugPrint('f1252 - ***[ Error 404 ]***');
        throw ErrorApi404();
      } else if (e.toString().indexOf('[403]') > 0) {
        debugPrint('f1252 - ***[ Error 403 ]***');
        throw ErrorApi403();
      } else {
        debugPrint('f1252 - ***[ Error Generic API ]***');
        throw ErrorApiError();
      }
    }
  }
}
