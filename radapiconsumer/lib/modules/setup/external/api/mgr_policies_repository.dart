import 'dart:convert';

import '../../../../utils/globals.dart';
import '../../../../utils/mgr_custom_dio.dart';
import 'package:flutter/cupertino.dart';

class MgrPoliciesRepository {
  // To do request install for actual device
  Future<String> getPolicies(String language) async {
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/policies/" + language;
    return await dio.get(url).then((res) async {
      debugPrint(res.toString());
      var dados = res.data['data'];
      return dados['content'];
    });
  }
}
