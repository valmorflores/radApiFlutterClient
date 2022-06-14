import 'package:dio/dio.dart';
import '../../../../modules/profile/infra/datasources/profile_datasource.dart';
import '../../../../modules/profile/infra/models/profile_model.dart';
import '../../../../utils/globals.dart';
import 'package:flutter/cupertino.dart';

class EIAPIProfileDatasource implements ProfileDatasource {
  final Dio dio;

  EIAPIProfileDatasource(this.dio);

  @override
  Future<List<ProfileModel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<ProfileModel>> getDetailById(int id) async {
    var url = app_urlapi + "/login";
    debugPrint('f8797 - Running profile - getDetailById (API) from: ' + url);
    debugPrint('f8797 - Parameters: ' + id.toString());
    var result = await this.dio.get(url);
    debugPrint('f8797 - after get data');
    if (result.statusCode == 200) {
      var jsonList = result.data['data'];
      debugPrint('f8797 - ' + jsonList.toString());
      List<ProfileModel> list = [];
      ProfileModel profile = ProfileModel();
      profile = ProfileModel.fromJson(jsonList[0]);
      list.add(profile);
      debugPrint('f8797 - done');
      return list;
    } else {
      debugPrint('f8797 - Error');
      throw Exception();
    }
  }

  @override
  Future<List<ProfileModel>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<int> getIdByEmail(String email) async {
    var url = app_urlapi + "/userlogin/id/" + email;
    int id;
    debugPrint('f4752 - Running profile - getIdByEmail (API) from: ' + url);
    try {
      var result = await this.dio.get(url);
      if (result.statusCode == 200) {
        var info = result.data['data']['staffid'];
        debugPrint('f4752 - Info: ' + info.toString());
        int id = 0;
        if (info != null) {
          id = int.parse(info.toString());
        }
        debugPrint('f4752 - Result: ' + id.toString());
        return id;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint('f4752 - Error in getIdByEmail: ' + e.toString());
      throw Exception(e);
    }
  }
}
