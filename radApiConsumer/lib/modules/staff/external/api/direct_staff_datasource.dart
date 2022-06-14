import 'dart:convert';

import '/modules/staff/infra/models/staff_model.dart';
import '/utils/globals.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';

class DirectStaffRepository {
  Future<List<StaffModel>> getAll() {
    var dio = WksCustomDio.withAuthentication().instance;
    debugPrint('GET ' + app_urlapi + '/staff ');
    return dio.get(app_urlapi + '/staff').then((res) {
      debugPrint(res.toString());
      List<StaffModel> staffs = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        staffs.add(StaffModel.fromJson(item));
      });
      return staffs;
    });
  }
}
