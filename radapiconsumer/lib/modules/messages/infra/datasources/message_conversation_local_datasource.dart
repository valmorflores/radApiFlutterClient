import '/modules/messages/infra/models/message_conversation_model.dart';

abstract class MessageConversationLocalDatasource {
  Future<List<MessageConversationModel>> searchText(String textSearch);
  Future<List<MessageConversationModel>> getAll();
  Future<List<MessageConversationModel>> getAllHeaders();
  Future<List<MessageConversationModel>> getById(int id);
  Future<List<MessageConversationModel>> addMessage(
      MessageConversationModel messageConversationModel);
}
