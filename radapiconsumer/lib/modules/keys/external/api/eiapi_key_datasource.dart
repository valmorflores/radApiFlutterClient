import 'package:dio/dio.dart';
import '../../../../modules/keys/infra/datasources/key_datasource.dart';
import '../../../../modules/keys/infra/models/key_model.dart';
import '../../../../utils/globals.dart';
import 'package:flutter/cupertino.dart';

class EIAPIKeyDatasource implements KeyDatasource {
  final Dio dio;

  EIAPIKeyDatasource(this.dio);

  @override
  Future<List<KeyModel>> getByKey(String key) async {
    var url = mgr_urlapi + "/workspaces/key/" + key;
    debugPrint('f4032 - Running key - getByKey (API) from: ' + url);
    List<KeyModel> list = [];
    try {
      var result = await this.dio.get(url);
      if (result.statusCode == 200) {
        var jsonList = result.data['data'] as List;
        var list = jsonList.map((item) => KeyModel.fromJson(item)).toList();
        debugPrint('f4032 - ' + list.toString());
        debugPrint('f4032 - Result size: ${list.length}');
        return list;
      } else {
        return list;
      }
    } catch (e) {
      debugPrint('f4032 - Error in getByKey: ' + e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<List<KeyModel>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
