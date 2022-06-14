import 'dart:convert';

import 'package:dio/dio.dart';
import '/modules/workspaces/infra/datasources/person_datasource.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/modules/workspaces/domain/entities/person_email_result.dart';
import '/modules/workspaces/infra/models/person_email_model.dart';
import '/modules/workspaces/infra/models/person_model.dart';
import '/utils/globals.dart';

class EIAPIPersonDatasource implements PersonDatasource {
  final Dio dio;

  EIAPIPersonDatasource(this.dio);

  @override
  Future<List<PersonModel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<PersonModel>> getByAlias(String searchText) async {
    var url = mgr_urlapi + "/login";
    debugPrint('Running profile - getByAlias (API) from: ' + url);
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => PersonModel(
                index: 0,
                id: item['id'],
                alias: item['alias'],
                name: item['name'],
              ))
          .toList();
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<PersonModel>> getPersons(String searchText) async {
    var url = mgr_urlapi + "/login";
    debugPrint('Running profile - getPersons (API) from: ' + url);
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => PersonModel(
                index: 0,
                id: item['id'],
                alias: item['alias'],
                name: item['name'],
              ))
          .toList();
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<PersonModel>> getById(int id) async {
    var url = mgr_urlapi + "/login";
    debugPrint('Running profile - getById (API) from: ' + url);
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => PersonModel(
                index: 0,
                id: item['id'],
                alias: item['alias'],
                name: item['name'],
              ))
          .toList();
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<PersonModel> postLogin(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = mgr_urlapi + "/login?email=" + email + '&password=' + password;
    var params = {'email': email, 'password': password};
    debugPrint('Running person - postLogin (API) from: ' + url);
    var result = await this.dio.post(url, data: jsonEncode(params));
    if (result.statusCode == 200) {
      var jsonList = result.data;
      var token = jsonList['token'];
      // Start token for Wks
      await prefs.setString('app_token', token);
      // Start token default
      await prefs.setString('token', token);
      List<PersonEmailModel> emails = [PersonEmailModel(email: email)];
      return PersonModel(
        index: 0,
        id: 1,
        alias: jsonList['username'],
        name: jsonList['username'],
        emails: emails,
      );
    } else {
      throw Exception();
    }
  }
}
