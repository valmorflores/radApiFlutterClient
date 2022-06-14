import 'dart:convert';

import 'package:dio/dio.dart';
import '/core/constants/ktables.dart';
import '/modules/contacts/domain/const/contacts_constants.dart';
import '/modules/contacts/infra/datasources/contact_datasource.dart';
import '/modules/contacts/infra/models/contact_model.dart';
import '/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIDBContactsDatasource implements ContactDatasource {
  EIDBContactsDatasource();

  @override
  Future<List<ContactModel>> searchText(String textSearch) async {
    var listCourses;
    var list = listCourses;
    return list;
  }

  @override
  Future<List<ContactModel>> updateById(ContactModel ContactModel) async {
    // TODO: implement clientAdd
    throw UnimplementedError();
  }

  @override
  Future<List<ContactModel>> clientAdd(String name) {
    // TODO: implement clientAdd
    throw UnimplementedError();
  }

  @override
  Future<List<ContactModel>> getUsers(String textSearch) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<List<ContactModel>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<ContactModel>> getAll() async {
    debugPrint('EIDB_CLIENTS_DATASOURCE_ via getAll');
    var dbTable =
        app_selected_workspace_name + kWorkspaceTblSeparator + kTblContacts;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var info = prefs.getString(dbTable);
    var result = jsonDecode(info!);
    var jsonList = result as List;
    List<ContactModel> list = [];
    debugPrint('f5807 - list with size => ' + jsonList.length.toString());
    jsonList.forEach((item) {
      list.add(ContactModel.fromJson(item));
    });
    debugPrint('f5807 - list complete');
    debugPrint('f5807 - done');
    return list;
  }

  @override
  Future<bool> deleteById(int id) {
    // TODO: implement deleteById
    throw UnimplementedError();
  }
}
