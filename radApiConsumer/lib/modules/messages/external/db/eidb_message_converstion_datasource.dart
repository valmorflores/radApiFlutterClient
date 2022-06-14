import 'dart:convert';

import '/core/constants/ktables.dart';
import '/modules/messages/infra/constants/message_conversation_constants.dart';
import '/modules/messages/infra/datasources/message_conversation_local_datasource.dart';
import '/modules/messages/infra/datasources/message_conversation_remote_datasource.dart';
import '/modules/messages/infra/models/message_conversation_model.dart';
import '/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIDBMessageConversationDatasource
    implements MessageConversationLocalDatasource {
  EIDBMessageConversationDatasource();

  @override
  Future<List<MessageConversationModel>> searchText(String textSearch) async {
    var listCourses;
    var list = listCourses;
    return list;
  }

  @override
  Future<List<MessageConversationModel>> getAll() async {
    debugPrint('f8445 - EIDB_ACTIVITY_DATASOURCE_ via getAll');
    var dbTable = app_selected_workspace_name +
        kWorkspaceTblSeparator +
        kTblMessageConversation;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var info = prefs.getString(dbTable);
    var result = jsonDecode(info!);
    var jsonList = result as List;
    List<MessageConversationModel> list = [];
    debugPrint('f8445 - list with size => ' + jsonList.length.toString());
    jsonList.forEach((item) {
      list.add(MessageConversationModel.fromJson(item));
    });
    debugPrint('f8445 - list complete');
    debugPrint('f8445 - done');
    return list;
  }

  @override
  Future<List<MessageConversationModel>> getAllHeaders() async {
    debugPrint('f8785 - EIDB_ACTIVITY_DATASOURCE_ via getAllHeaders');
    var dbTable = app_selected_workspace_name +
        kWorkspaceTblSeparator +
        kTblMessageConversation;
    debugPrint('f8785 - Getting from local: $dbTable');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var info = prefs.getString(dbTable);
    var result = jsonDecode(info!);
    var jsonList = result as List;
    List<MessageConversationModel> list = [];
    debugPrint('f8785 - list with size => ' + jsonList.length.toString());
    jsonList.forEach((item) {
      list.add(MessageConversationModel.fromJson(item));
    });
    debugPrint('f8785 - list complete');
    debugPrint('f8785 - done');
    return list;
  }

  @override
  Future<List<MessageConversationModel>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<MessageConversationModel>> addMessage(
      MessageConversationModel messageConversationModel) {
    // TODO: implement addMessage
    throw UnimplementedError();
  }
}
