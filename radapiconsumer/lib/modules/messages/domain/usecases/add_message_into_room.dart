import 'package:dartz/dartz.dart';
import '/modules/messages/domain/entities/message_conversation_result.dart';
import '/modules/messages/domain/errors/errors.dart';
import '/modules/messages/domain/repositories/message_conversation_repository.dart';

mixin AddMessageIntoRoom {
  Future<Either<Failure, List<MessageConversationResult>>> call(
      List<MessageConversationResult> messages);
}

class AddMessageIntoRoomImpl implements AddMessageIntoRoom {
  final MessageConversationRepository repository;

  AddMessageIntoRoomImpl(this.repository);

  @override
  Future<Either<Failure, List<MessageConversationResult>>> call(
      List<MessageConversationResult> messages) async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.addMessages(messages);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
