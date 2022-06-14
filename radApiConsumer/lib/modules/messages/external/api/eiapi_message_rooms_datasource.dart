import 'dart:convert';

import 'package:dio/dio.dart';
import '/modules/contacts/infra/models/contact_model.dart';
import '/modules/messages/infra/constants/message_conversation_constants.dart';
import '/modules/messages/infra/datasources/message_room_datasource.dart';
import '/modules/messages/infra/models/message_room_model.dart';
import '/modules/messages/infra/models/message_conversation_members_model.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EIAPIMessageRoomsDatasource implements MessageRoomDatasource {
  final Dio dio;

  EIAPIMessageRoomsDatasource(this.dio);

  @override
  Future<List<ContactModel>> getContactsByRoom(int id) {
    // TODO: implement getContactsByRoom
    throw UnimplementedError();
  }

  @override
  Future<List<MessageConversationMembersModel>> getMembersByRoom(int id) {
    // TODO: implement getMembersByRoom
    throw UnimplementedError();
  }

  @override
  Future<List<MessageRoomModel>> getRoomById(int id) {
    // TODO: implement getRoomById
    throw UnimplementedError();
  }

  @override
  Future<List<MessageRoomModel>> getRooms() async {
    debugPrint('f1872 - EIAPI_MESSAGE_CONVERSATION_DATASOURCE_ via getById');
    var url = app_urlapi + "/messages/conversations";
    debugPrint('f1872 - CONVERSATION: url: ${url}');
    var result = await this.dio.get(url);
    if (result.statusCode == 200) {
      var jsonList = result.data['data']; // as List;

      List<MessageRoomModel> list = [];
      jsonList.forEach((item) {
        list.add(MessageRoomModel(
          id: item['id'] ?? 0,
          title: item['title'],
          membersId: [],
          contactsId: [],
          isContact: item['is_contact'] != 0,
          user1: item['user1'] ?? 0,
          user2: item['user2'] ?? 0,
          type: item['type'],
        ));
      });
      // Save
      var dbTable =
          app_selected_workspace_name + ':' + kTblMessageConversationRooms;
      debugPrint('f1872 - Saving local rooms list: ' + dbTable);
      /*SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(dbTable, jsonEncode(list));
      debugPrint('f1872 - Table: ' + dbTable);
      debugPrint('f1872 - done');*/
      return list;
    } else {
      throw Exception();
    }
  }
}
