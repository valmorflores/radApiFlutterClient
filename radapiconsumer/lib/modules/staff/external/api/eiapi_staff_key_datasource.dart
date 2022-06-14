import 'package:dio/dio.dart';
import '/modules/staff/infra/datasources/staff_key_datasource.dart';
import '/modules/staff/infra/models/staff_key_model.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';

class EIAPIStaffKeyDatasource implements StaffKeyDatasource {
  final Dio dio;
  EIAPIStaffKeyDatasource(this.dio);

  @override
  Future<List<StaffKeyModel>> addKey(StaffKeyModel staffKeyModel) async {
    String url = app_urlapi + '/staff/key';
    debugPrint('f1002 - Staff key insert via [post] $url');
    debugPrint('f1002 - Parameters: ' + staffKeyModel.toJson().toString());
    return dio.post(url, data: staffKeyModel.toJson()).then((res) {
      debugPrint(res.data.toString());
      List<StaffKeyModel> staffs = [];
      //var dados = res.data['data'];
      //debugPrint('f1002 - ' + dados.toString());
      //staffs.add(StaffKeyModel.fromJson(dados));
      debugPrint('f1002 - done');
      return staffs;
    });
  }

  @override
  Future<List<StaffKeyModel>> getLastKey(StaffKeyModel staffKeyModel) {
    debugPrint('f1542 - Start getting: ' + app_urlapi + '/staff ');
    return dio.get(app_urlapi + '/staff/key').then((res) async {
      //debugPrint(res.toString());
      //return res.data.map<ClientModel>(ClientModel.fromJson).toList();
      List<StaffKeyModel> staffs = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        staffs.add(StaffKeyModel.fromJson(item));
      });
      return staffs;
    });
  }

  @override
  Future<List<StaffKeyModel>> getMy(int staffid) {
    debugPrint('f1742 - Start getting ' + app_urlapi + '/staff/me');
    return dio.get(app_urlapi + '/staff/me').then((res) {
      debugPrint('f1742 - ' + res.toString());
      List<StaffKeyModel> staffs = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        staffs.add(StaffKeyModel.fromJson(item));
      });
      debugPrint('f1742 - done');
      return staffs;
    });
  }

  @override
  Future<List<StaffKeyModel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<StaffKeyModel>> patchStaffKey(StaffKeyModel staffKeyModel) async {
    List<StaffKeyModel> staffs = [];
    String url = app_urlapi + '/staffs/key';
    debugPrint('f1002 - Staff key update via [patch] $url');
    debugPrint('f1002 - Parameters: ' + staffKeyModel.toJson().toString());
    var result = await dio.patch(url, data: staffKeyModel.toJson());
    if (result.statusCode == 200) {
      //debugPrint(result.data.toString());
      //var dados = res.data['data'];
      //debugPrint('f1002 - ' + dados.toString());
      //staffs.add(StaffKeyModel.fromJson(dados));
      debugPrint('f1002 - done');
    } else {
      debugPrint('f1002 - error executing change on server');
    }
    return staffs;
  }
}
