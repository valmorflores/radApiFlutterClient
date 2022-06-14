import 'dart:convert';

import 'package:dio/dio.dart';
import '/core/constants/ktables.dart';
import '/modules/staff/domain/const/staff_constants.dart';
import '/modules/staff/infra/datasources/staff_datasource.dart';
import '/modules/staff/infra/models/staff_model.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIAPIStaffDatasource implements StaffDatasource {
  final Dio dio;
  EIAPIStaffDatasource(this.dio);

  Future<List<StaffModel>> getAll() async {
    debugPrint('f1542 - Start getting: ' + app_urlapi + '/staff ');
    return dio.get(app_urlapi + '/staff').then((res) async {
      //debugPrint(res.toString());
      //return res.data.map<ClientModel>(ClientModel.fromJson).toList();
      List<StaffModel> staffs = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        staffs.add(StaffModel.fromJson(item));
      });
      debugPrint('f1542 - Saving local staffs...');
      var dbTable =
          app_selected_workspace_name + kWorkspaceTblSeparator + kTblStaff;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(dbTable, jsonEncode(dados));
      debugPrint('f1542 - Table: ' + dbTable);
      debugPrint('f1542 - done');
      return staffs;
    });
  }

  Future<List<StaffModel>> getById(int id) async {
    String _url = app_urlapi + '/staff/' + id.toString();
    debugPrint('f1452 - Start getting $_url');
    return dio.get(_url).then((res) {
      List<StaffModel> staffs = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        staffs.add(StaffModel.fromJson(item));
      });
      debugPrint('f1452 - done');
      return staffs;
    });
  }

  @override
  Future<List<StaffModel>> searchText(String textSearch) {
    // TODO: implement searchText
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> updateById(StaffModel clientModel) {
    // TODO: implement updateById
    throw UnimplementedError();
  }

  @override
  Future<List<StaffModel>> getMe() {
    debugPrint('f1052 - Start getting ' + app_urlapi + '/staff/me');
    return dio.get(app_urlapi + '/staff/me').then((res) {
      debugPrint(res.toString());
      List<StaffModel> staffs = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        staffs.add(StaffModel.fromJson(item));
      });
      debugPrint('f1052 - done');
      return staffs;
    });
  }

  @override
  Future<List<StaffModel>> addStaff(StaffModel staff) async {
    debugPrint('f1252 - Staff insert [post]' + app_urlapi + '/staff');
    List<StaffModel> staffs =
        await dio.post(app_urlapi + '/staff', data: staff.toJson()).then((res) {
      debugPrint(res.data.toString());
      List<StaffModel> staffs = [];
      var dados = res.data['data'];
      debugPrint('f1252 - ' + dados.toString());
      staffs.add(StaffModel.fromJson(dados));
      debugPrint('f1252 - done');
      return staffs;
    });
    /* Insert into tbluser via another address */
    debugPrint('f1252 - into tbluser');
    var infoUser = {
      'name': staff.email,
      'email': staff.email,
      'password': 'teste123'
    };
    var url_useradd = app_urlapi + '/userlogin/add';
    debugPrint('f1252 - url => ' + url_useradd.toString());
    debugPrint('f1252 - Parameters => ' + infoUser.toString());
    List<StaffModel> userAdd =
        await dio.post(url_useradd, data: infoUser).then((res) {
      debugPrint('f1252 - ' + res.data.toString());
      List<StaffModel> staffs = [];
      var dados = res.data['data'];
      debugPrint('f1252 - ' + dados.toString());
      staffs.add(StaffModel.fromJson(dados));
      debugPrint('f1252 - done');
      return staffs;
    });
    return staffs;
  }

  @override
  Future<List<StaffModel>> patchStaffImage(StaffModel staffModel) async {
    String _url = app_urlapi + '/staffs/${staffModel.staffid}/image';
    debugPrint('f1252 - Staff [patch] url: $_url');
    var _params = {
      'staffid': staffModel.staffid,
      'profile_image': staffModel.profileImage
    };
    List<StaffModel> staffs = [];
    var result = await dio.patch(_url, data: jsonEncode(_params));
    if (result.statusCode == 200) {
      debugPrint(result.data.toString());
      List<StaffModel> staffs = [];
      var dados = result.data['data'];
      debugPrint('f1252 - ' + dados.toString());
      staffs.add(StaffModel.fromJson(dados));
      debugPrint('f1252 - done');
      return staffs;
    } else {
      debugPrint('f1252 - error image patch to database');
    }
    return [];
  }

  @override
  Future<List<StaffModel>> patchStaffName(StaffModel staffModel) async {
    String _url = app_urlapi + '/staffs/${staffModel.staffid}/name';
    debugPrint('f1252 - Staff [patch] url: $_url');
    var _params = {
      'staffid': staffModel.staffid,
      'firstname': staffModel.firstname,
      'lastname': staffModel.lastname,
    };
    List<StaffModel> staffs = [];
    var result = await dio.patch(_url, data: jsonEncode(_params));
    if (result.statusCode == 200) {
      debugPrint(result.data.toString());
      List<StaffModel> staffs = [];
      var dados = result.data['data'][0];
      staffs.add(StaffModel(
        staffid: dados['staffid'] ?? 0,
        firstname: dados['firstname'] ?? '',
        lastname: dados['lastname'] ?? '',
      ));
      //debugPrint('f1252 - ' + dados.toString());
      //staffs.add(StaffModel.fromJson(dados));
      //debugPrint('f1252 - done');
      return staffs;
    } else {
      debugPrint('f1252 - error image patch to database');
    }
    return [];
  }
}
