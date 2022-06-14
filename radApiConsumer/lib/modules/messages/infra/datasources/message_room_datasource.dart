import '/modules/contacts/infra/models/contact_model.dart';
import '/modules/messages/infra/models/message_conversation_members_model.dart';
import '/modules/messages/infra/models/message_room_model.dart';

abstract class MessageRoomDatasource {
  Future<List<MessageRoomModel>> getRooms();
  Future<List<MessageRoomModel>> getRoomById(int id);
  Future<List<MessageConversationMembersModel>> getMembersByRoom(int id);
  Future<List<ContactModel>> getContactsByRoom(int id);
}
