import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

class CustomDio {
  var _dio;

  CustomDio() {
    BaseOptions options = BaseOptions(
        baseUrl: app_urlapi,
        receiveDataWhenStatusError: true,
        connectTimeout: 256 * 1000, // 256 seconds
        receiveTimeout: 256 * 1000 // 256 seconds
        );
    _dio = Dio(options);
  }

  CustomDio.withAuthentication() {
    BaseOptions options = BaseOptions(
        baseUrl: app_urlapi,
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
      return;
      //todo:?precisa? return options;
    }, onResponse: (response, handler) {
      // Do something with response data
      return;
      //todo: return response; // continue
    }, onError: (error, handler) async {
      // Do something with response error
      if (error.response?.statusCode == 403) {
        // update token and repeatadd(InterceptorsWrapper(
      }
      return;
      //todo:precisa? return error;
    }));
  }

  Dio get instance => _dio;
}
