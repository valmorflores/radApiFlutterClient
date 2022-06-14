import 'dart:convert';

import 'package:dio/dio.dart';
import '/core/constants/ktables.dart';
import '/modules/messages/infra/constants/message_conversation_constants.dart';
import '/modules/messages/infra/datasources/message_conversation_remote_datasource.dart';
import '/modules/messages/infra/models/message_conversation_model.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIAPIMessageConversationDatasource
    implements MessageConversationRemoteDatasource {
  final Dio dio;

  EIAPIMessageConversationDatasource(this.dio);

  @override
  Future<List<MessageConversationModel>> searchText(String textSearch) async {
    var str_valid = textSearch.trim().replaceAll(' ', '+');
    var listCourses;
    var listClients;
    debugPrint('f7408 - EIAPI_MESSAGE_CONVERSATION_DATASOURCE_ via searchText');
    var list = listCourses;
    return list;
  }

  @override
  Future<List<MessageConversationModel>> getById(int id) async {
    /*{
            "id": 1,
            "cid": 1,
            "member_id": 1,
            "contact_id": 0,
            "message": "SAMPLE",
            "file_path": "",
            "image_path": "",
            "sticker_path": null,
            "send_like": 0,
            "time_created": 1554846434,
            "gif_path": null
        },*/

    //debugPrint('f1802 - EIAPI_MESSAGE_CONVERSATION_DATASOURCE_ via getById');
    var url = app_urlapi + "/messages/${id}";
    //debugPrint('f1802 - MESSAGE: url: ${url}');
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      List<MessageConversationModel> list = [];
      /*if (result.data.isEmpty) {
        return list;
      }
      if (result.data.trim() == '') {
        return list;
      }*/
      var jsonList = result.data['data']; // as List;
      jsonList.forEach((item) {
        list.add(MessageConversationModel(
          index: 0,
          id: item['id'] ?? 0,
          message: item['message'],
          memberId: item['member_id'] ?? 0,
          contactId: item['contact_id'] ?? 0,
          timeCreated: item['time_created'] ?? '',
          sendLike: item['send_like'] ?? '',
        ));
      });
      // Save
      var dbTable = app_selected_workspace_name +
          ':' +
          kTblMessageConversation +
          '_' +
          id.toString();
      //debugPrint('f1802 - Saving local conversation list: ' + dbTable);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(dbTable, jsonEncode(list));
      //debugPrint('f1802 - Table: ' + dbTable);
      //debugPrint('f1802 - done');
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<MessageConversationModel>> getAll() async {
    debugPrint('f1972 - EIAPI_MESSAGE_CONVERSATION_DATASOURCE_ via getAll');
    var url = app_urlapi + "/activities";
    debugPrint('f1972 - url: $url');
    var result = await this.dio.get(url);
    //var result = await this.dio.get(urlapi + "/contacts");
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => MessageConversationModel(
                id: item['id'] ?? 0,
                index: 0,
                memberId: item['member_id'],
                contactId: item['contact_id'],
                message: item['message'],
              ))
          .toList();

      // Save
      var dbTable = app_selected_workspace_name +
          kWorkspaceTblSeparator +
          kTblMessageConversation;
      debugPrint('f1972 - Saving local activities: ' + dbTable);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(dbTable, jsonEncode(list));
      debugPrint('f1972 - Table: ' + dbTable);
      debugPrint('f1972 - done');
      // result
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<MessageConversationModel>> getAllHeaders() async {
    debugPrint(
        'f1452 - EIAPI_MESSAGE_CONVERSATION_DATASOURCE_ via getAllHeaders');
    var url = app_urlapi + "/activities";
    debugPrint('f1452 - url: $url');
    var result = await this.dio.get(url);
    //var result = await this.dio.get(urlapi + "/contacts");
    if (result.statusCode == 200) {
      var jsonList = result.data['data'] as List;
      var list = jsonList
          .map((item) => MessageConversationModel(
                id: item['id'],
                message: item['message'],
                contactId: item['contact_id'],
                memberId: item['member_id'],
              ))
          .toList();

      // Save
      var dbTable = app_selected_workspace_name +
          kWorkspaceTblSeparator +
          kTblMessageConversation;
      debugPrint('f1452 - Saving local activities: ' + dbTable);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(dbTable, jsonEncode(list));
      debugPrint('f1452 - Table: ' + dbTable);
      debugPrint('f1452 - done');
      // result
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<MessageConversationModel>> addMessage(
      MessageConversationModel messageConversationModel) async {
    debugPrint('f7429 - EIAPI_MESSAGE_CONVERSATION_DATASOURCE_ activityAdd');
    var url = app_urlapi +
        "/messageconversation?id=0&cid=${messageConversationModel.cid}";
    debugPrint('f7429 - [Post] url: ' + url);
    var list = {
      'message': messageConversationModel.message,
      'contact_id': messageConversationModel.contactId,
      'member_id': messageConversationModel.memberId,
      'cid': messageConversationModel.cid,
      'send_like': messageConversationModel.sendLike,
      'id': 0
    };
    var result = await this.dio.post(url, data: jsonEncode(list));
    if (result.statusCode == 200) {
      debugPrint('f7429 - Sucesso no retorno...');
      List<MessageConversationModel> data = [];
      var jsonList = result.data['data'] as List;
      data = jsonList
          .map((item) => MessageConversationModel(
                id: item['id'],
                message: item['message'],
              ))
          .toList();
      //data.add(MessageConversationModel(id: 0, name: name));
      return data;
    } else {
      debugPrint('Erro no retorno...');
      throw Exception();
    }
  }

  @override
  Future<List<MessageConversationModel>> xaddMessages(
      List<MessageConversationModel> messageConversationModel) async {
    List<MessageConversationModel> resultMessageConversationModel;
    resultMessageConversationModel = [];

    messageConversationModel.forEach((element) async {
      debugPrint('f7429 - EIAPI_MESSAGE_CONVERSATION_DATASOURCE_ post');
      String _url = app_urlapi + "/messages/${element.cid}";
      debugPrint('f7429 - [Post] url: ' + _url);
      var list = {
        'message': element.message,
        'contact_id': element.contactId,
        'member_id': element.memberId,
        'cid': element.cid,
        'send_like': element.sendLike,
        'id': 0
      };
      var result = await this.dio.post(_url, data: jsonEncode(list));
      if (result.statusCode == 200) {
        debugPrint('f7429 - Sucesso no retorno...');
        var jsonList = result.data['data'] as List;
        jsonList
            .map((item) =>
                resultMessageConversationModel.add(MessageConversationModel(
                  id: item['id'],
                  message: item['message'],
                  memberId: item['member_id'],
                  timeCreated: item['time_created'],
                  sendLike: item['send_like'],
                )))
            .toList();
      } else {
        debugPrint('Erro no retorno...');
        throw Exception();
      }
    });
    return resultMessageConversationModel;
  }

  @override
  Future<int> getStartConversationWith(int staffid) async {
    int cidConversation = 0;
    debugPrint(
        'f7458 - EIAPI_MESSAGE_CONVERSATION_DATASOURCE_ get information');
    String _url = app_urlapi + "/messages/conversation/${staffid.toString()}";
    debugPrint('f7458 - [GET] url: ' + _url);
    var result = await this.dio.get(_url);
    if (result.statusCode == 200) {
      debugPrint('f7458 - Sucesso no retorno...');
      var jsonList = result.data['data'] as List;
      jsonList.forEach((element) {
        cidConversation = element['id'];
      });
      debugPrint('f7458 - $cidConversation');
    } else {
      debugPrint('f7458 - Erro no retorno da API');
      throw Exception();
    }
    return cidConversation;
  }

  @override
  Future<List<MessageConversationModel>> addMessages(
      List<MessageConversationModel> messageConversationModel) {
    // TODO: implement addMessages
    throw UnimplementedError();
  }
}
