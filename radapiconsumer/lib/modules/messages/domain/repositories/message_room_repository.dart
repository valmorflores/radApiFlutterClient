import 'package:dartz/dartz.dart';
import '/modules/contacts/domain/entities/contact_result.dart';
import '/modules/messages/domain/entities/message_conversation_members_result.dart';
import '/modules/messages/domain/entities/message_room_result.dart';
import '/modules/messages/domain/errors/errors.dart';

abstract class MessageRoomRepository {
  Future<Either<Failure, List<MessageRoomResult>>> getRooms();
  Future<Either<Failure, List<MessageRoomResult>>> getRoomById(int id);
  Future<Either<Failure, List<MessageConversationMembersResult>>>
      getMembersByRoom(int id);
  Future<Either<Failure, List<ContactResult>>> getContactsByRoom(int id);
}
