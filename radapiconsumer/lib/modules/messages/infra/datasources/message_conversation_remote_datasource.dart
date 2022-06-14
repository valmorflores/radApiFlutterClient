import '/modules/messages/infra/models/message_conversation_model.dart';

abstract class MessageConversationRemoteDatasource {
  Future<List<MessageConversationModel>> searchText(String textSearch);
  Future<List<MessageConversationModel>> getAll();
  Future<List<MessageConversationModel>> getAllHeaders();
  Future<List<MessageConversationModel>> getById(int id);
  Future<List<MessageConversationModel>> addMessages(
      List<MessageConversationModel> messageConversationModel);
  Future<int> getStartConversationWith(int staffid);
}
