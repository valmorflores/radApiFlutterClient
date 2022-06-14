import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/ktables.dart';
import '../../modules/profile/infra/models/profile_model.dart';
import '../../utils/wks_custom_dio.dart';
import '../../utils/globals.dart';

class LoginRepository {
  Future<bool> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = '';
    String? _userkey = prefs.getString('myuserkey');
    String urlLogin =
        app_urlapi + '/user/login?email=valmorflores@gmail.com&password=160302';
    var dataLogin = {'email': 'user@gmail.com', 'password': 'teste123'};
    debugPrint('f7801 - user key => ' + _userkey.toString());
    if (_userkey == null) {
      app_userkey = '';
    } else {
      app_userkey = (await this.getUserKey())!;
      debugPrint(
          'f7801 - get userkey via function getUserKey() => ' + _userkey);
    }
    debugPrint('f7801 - Starting login API = ' + urlLogin);
    var dio = WksCustomDio().instance;
    dio.post(urlLogin, data: dataLogin).then((res) async {
      debugPrint('f7801 - Response from Api server');
      token = res.data['token'];
      debugPrint('f7801 - Token: ' + token);
      await prefs.setString('token', res.data['token']);
      // If have key, use key else default user and password
      // for first login / start app
      if (app_userkey != '') {
        try {
          await loginIdentified();
        } catch (e) {
          debugPrint('f7801 - Error');
          throw Exception('f7801 - Error from login identified');
        }
      }
    }).catchError((e) {
      debugPrint(app_urlapi);
      debugPrint(e);
      throw Exception('f7801 - Error on login');
    });
    debugPrint('f7801 - Done');
    return true;
  }

  Future<bool> loginIdentified() async {
    debugPrint('f7801:2 - start login loginIdentified()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = WksCustomDio.withAuthentication().instance;
    String urlLogin = app_urlapi + '/login/' + app_userkey;
    var dataLogin = {};
    debugPrint('f7801:2 - app_userkey information = ' + app_userkey);
    debugPrint('f7801:2 - urllogin => ' + urlLogin);
    dio.post(urlLogin, data: dataLogin).then((res) async {
      await prefs.setString('token', res.data['token']);
      //
      //
      //
      //
      // ----------- SAVE PROFILE LOGGED ----------------
      // Get user loggin data
      //
      //
      //
      var staff = res.data['staff'][0];
      app_user = ProfileModel(
        id: staff['staffid'],
        staffid: staff['staffid'],
        email: staff['email'],
        firstname: staff['firstname'],
        lastname: staff['lastname'],
        profileImage: staff['profile_image'],
      );
      // saving user data to local
      var _dbTable = app_selected_workspace_name +
          kWorkspaceTblSeparator +
          kTblUserProfile;
      debugPrint('f7801:2 - Saving profile to: $_dbTable');
      await prefs.setString(_dbTable, jsonEncode(app_user));
      debugPrint(
          'f7801:2 - Saved done: ${staff['firstname']} - ${staff['email']}');
    }).catchError((e) async {
      var _dbTable = app_selected_workspace_name +
          kWorkspaceTblSeparator +
          kTblUserProfile;
      debugPrint('f7801:3 - Acesso negado com id ' + app_userkey);
      debugPrint('f7801:3 - Exist local information in: $_dbTable?');
      if (prefs.containsKey(_dbTable)) {
        debugPrint('f7801:3 - Found local profile, load from file: ' +
            app_selected_workspace_name +
            kTblUserProfile);
        String? _userProfileFromFile = prefs.getString(_dbTable);
        var json = jsonDecode(_userProfileFromFile!);
        app_user = ProfileModel.fromJson(json);
      } else {
        debugPrint('f7801:3 - Does not exists! Setting blank profile');
        app_user = ProfileModel(id: 0);
      }
      debugPrint('f7801:2 - urlAPI => ' + app_urlapi);
      debugPrint('f7801:2 - error, start:');
      debugPrint('f7801:2 - error, end.');
      //404
      throw Exception('f7801:2 - Error on identified login');
    });
    debugPrint('f7801:2 - done');
    return true;
  }

  Future<bool> isValidKey(String key) async {
    debugPrint('f8638 - isValidKey()? $key');
    if (key == null) {
      key = '';
    }
    if (key == '') {
      debugPrint('f8638 - key is empty. Validation is not enabled.');
      return false;
    }
    var dio = WksCustomDio.withAuthentication().instance;
    debugPrint('f8638 - app_userkey information = $app_userkey');
    debugPrint('f8638 - key by parameter, information = $key');
    var url = app_urlapi + '/login/' + key;
    debugPrint('f8638 - url: ' + url);
    return await dio.post(url).then((res) async {
      debugPrint('f8638 - result/data: ' + res.data.toString());
      if (res.statusCode == 200) {
        if (res.data['last_validation'] != null) {
          var lastvalidation = res.data['last_validation'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('last_validation', lastvalidation.toString());
          await prefs.setString(
              'last_validation_local',
              DateTime.now()
                  .millisecondsSinceEpoch
                  .toString()
                  .substring(0, 10));
          await prefs.setString(
              'key_' + key + '_is_valid', (lastvalidation == '' ? '0' : '1'));
          await prefs.setString(
              'key_' + key + '_is_active', res.data['active'].toString());
        }
      }
      debugPrint('f8638 - done true');
      return true;
    }).catchError((e) {
      debugPrint('f8638 - ' + e.toString());
      debugPrint('f8638 - done false');
      return false;
    });
  }

  Future<bool> setUserKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('myuserkey', key);
    app_userkey = key;
    return true;
  }

  Future<String?> getUserKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('myuserkey');
  }

  Future<bool> removeUserKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove('myuserkey');
  }
}
