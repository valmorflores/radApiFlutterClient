import 'package:dartz/dartz.dart';
import '/modules/messages/domain/entities/message_conversation_result.dart';
import '/modules/messages/domain/errors/errors.dart';

abstract class MessageConversationRepository {
  Future<Either<Failure, List<MessageConversationResult>>> getConversationById(
      int id);
  Future<Either<Failure, List<MessageConversationResult>>>
      getConversationAllHeaders();
  Future<Either<Failure, List<MessageConversationResult>>> addMessages(
      List<MessageConversationResult> messages);
  Future<Either<Failure, List<MessageConversationResult>>> removeMessageById(
      int id);
  Future<Either<Failure, int>> getStartConversationWith(int id);
}
