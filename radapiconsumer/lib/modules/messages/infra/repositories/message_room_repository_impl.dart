import 'package:dartz/dartz.dart';
import '/core/platform/network_info.dart';
import '/modules/messages/domain/entities/message_room_result.dart';
import '/modules/messages/domain/entities/message_conversation_members_result.dart';
import '/modules/contacts/domain/entities/contact_result.dart';
import '/modules/messages/domain/repositories/message_room_repository.dart';
import '/modules/messages/infra/datasources/message_room_datasource.dart';
import '/modules/messages/domain/errors/errors.dart';
import 'package:flutter/cupertino.dart';

class MessageRoomRepositoryImpl implements MessageRoomRepository {
  final MessageRoomDatasource datasourceRemote;
  final NetworkInfo networkInfo;

  MessageRoomRepositoryImpl(
      {required this.datasourceRemote, required this.networkInfo});

  @override
  Future<Either<Failure, List<ContactResult>>> getContactsByRoom(int id) {
    // TODO: implement getContactsByRoom
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<MessageConversationMembersResult>>>
      getMembersByRoom(int id) {
    // TODO: implement getMembersByRoom
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<MessageRoomResult>>> getRoomById(int id) {
    // TODO: implement getRoomById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<MessageRoomResult>>> getRooms() async {
    List<MessageRoomResult> list;
    try {
      list = await datasourceRemote.getRooms();
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }
    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
