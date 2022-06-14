import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../../core/constants/ktables.dart';
import '../../../../modules/contacts/domain/const/contacts_constants.dart';
import '../../../../modules/contacts/infra/datasources/contact_datasource.dart';
import '../../../../modules/contacts/infra/models/contact_model.dart';
import '../../../../utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIAPIContactDatasource implements ContactDatasource {
  final Dio dio;

  EIAPIContactDatasource(this.dio);

  @override
  Future<List<ContactModel>> getUsers(String textSearch) async {
    var strValid = textSearch.trim().replaceAll(' ', '+');
    var listContacts;
    var listClients;
    try {
      listContacts = await list_search_table_contact(strValid);
    } catch (e) {
      listContacts = [
        new ContactModel(
          id: -1,
          firstname: "Contatos",
        )
      ];
    }
    var list = listContacts;
    return list;
  }

  Future<List<ContactModel>> list_search_table_contact(final String str) async {
    var url = app_urlapi + "/contacts?q=${str}";
    var result = await this.dio.get(url);
    //var result = await this.dio.get(urlapi + "/contacts");
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => ContactModel(
              id: item['id'],
              firstname: item['firstname'],
              lastname: item['lastname'],
              email: item['email'],
              userid: item['userid']))
          .toList();

      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<ContactModel>> getAll() async {
    var url = app_urlapi + "/contacts";
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => ContactModel(
              id: item['id'],
              firstname: item['firstname'],
              lastname: item['lastname'],
              email: item['email'],
              active: item['active'],
              datecreated: item['date_created'],
              lastIp: item['last_ip'],
              lastLoginTime: item['last_login_time'],
              userid: item['userid']))
          .toList();
      // Save to local
      debugPrint('f5201 - Saving local staff...');
      var dbTable =
          app_selected_workspace_name + kWorkspaceTblSeparator + kTblContacts;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(dbTable, jsonEncode(jsonList));
      debugPrint('f5201 - Table: ' + dbTable);
      debugPrint('f5201 - done');
      return list;
    } else if (result.statusCode == 204) {
      debugPrint('f5201 - Status 204 - Result without constacts informations');
      return [];
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<ContactModel>> getById(int id) async {
    var url = app_urlapi + "/contacts/${id}";
    debugPrint('Running getById (API) from: ' + url);
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => ContactModel(
              index: 0,
              id: item['id'],
              firstname: item['firstname'],
              lastname: item['lastname'],
              phonenumber: item['phonenumber'],
              title: item['title'],
              email: item['email'],
              lastLogin: item['last_login'],
              datecreated: item['date_created'],
              lastIp: item['last_ip'],
              active: item['active'],
              lastLoginTime: item['last_login_time'],
              userid: item['userid']))
          .toList();
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<bool> deleteById(int id) async {
    var url = app_urlapi + "/contacts/${id}";
    debugPrint('f7404 - Running delete (API) from: ' + url);
    var result = await this.dio.delete(url);
    if (result.statusCode == 200) {
      return true;
    } else {
      throw Exception();
    }
  }
}
