import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

class WksCustomDio {
  var _dio;
  final bool _debugDio = false;

  WksCustomDio() {
    _debugDio ? debugPrint('f7498 - WksCustomDio initializing...') : null;
    BaseOptions options = BaseOptions(
        baseUrl: app_urlapi,
        receiveDataWhenStatusError: true,
        connectTimeout: 256 * 1000, // 256 seconds
        receiveTimeout: 256 * 1000 // 256 seconds
        );
    _dio = Dio(options);
  }

  WksCustomDio.withAuthentication() {
    _debugDio
        ? debugPrint('f7498 - WksCustomDio with authentication...')
        : null;
    BaseOptions options = BaseOptions(
        baseUrl: app_urlapi,
        receiveDataWhenStatusError: true,
        connectTimeout: 256 * 1000, // 256 seconds
        receiveTimeout: 256 * 1000 // 256 seconds
        );
    _dio = Dio(options);
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token$app_selected_workspace_name');
        _debugDio
            ? debugPrint('f7498 - onRequest, preparing request parameters')
            : null;
        if (token != null) {
          if (token != "") {
            _debugDio
                ? debugPrint('f7498 - With autorization Bearer ' + token)
                : null;
            options.headers['Authorization'] = 'Bearer ' + token;
          }
        }
        if (app_workspace_name != '') {
          options.headers['workspace'] = app_workspace_name;
          _debugDio
              ? debugPrint(
                  'f7498 - WksCustomDio - Running with app_workspace_name[header:workspace] = ' +
                      app_workspace_name)
              : null;
        }
        _debugDio ? debugPrint('f7498 - onRequest finished...') : null;
        _debugDio ? debugPrint('f7498 - options') : null;
        _debugDio
            ? debugPrint('f7498 - options: ' + options.headers.toString())
            : null;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _debugDio ? debugPrint('f7498 - response') : null;
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        _debugDio ? debugPrint('f7498 - error') : null;
        return handler.next(e);
      },
    ));
  }

  Dio get instance => _dio;
}
