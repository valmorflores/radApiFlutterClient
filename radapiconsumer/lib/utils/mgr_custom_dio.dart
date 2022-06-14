import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

class MgrCustomDio {
  var _dio;

  MgrCustomDio() {
    BaseOptions options = BaseOptions(
        baseUrl: mgr_urlapi,
        receiveDataWhenStatusError: true,
        connectTimeout: 256 * 1000, // 256 seconds
        receiveTimeout: 256 * 1000 // 256 seconds
        );
    _dio = Dio(options);
  }

  MgrCustomDio.withAuthentication() {
    BaseOptions options = BaseOptions(
        baseUrl: mgr_urlapi,
        receiveDataWhenStatusError: true,
        connectTimeout: 256 * 1000, // 256 seconds
        receiveTimeout: 256 * 1000 // 256 seconds
        );
    _dio = Dio(options);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        if (token != "") {
          options.headers['Authorization'] = 'Bearer ' + token;
        }
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      debugPrint('f7477 - mgrCustomDio - Response:');
      debugPrint('f7477 - ' + response.toString());
      debugPrint('f7477 - mgrCustomDio - done');
      return handler.next(response);
    }, onError: (e, handler) {
      debugPrint('f7477 - mgrCustomDio - Error');
      debugPrint('f7477 - ' + e.toString());
      return handler.next(e);
    }));
  }

  Dio get instance => _dio;
}
