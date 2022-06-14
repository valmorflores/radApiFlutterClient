import 'package:dartz/dartz.dart';
import '/modules/messages/domain/entities/message_conversation_result.dart';
import '/modules/messages/domain/errors/errors.dart';
import '/modules/messages/domain/repositories/message_conversation_repository.dart';

mixin GetMessageConversationById {
  Future<Either<Failure, List<MessageConversationResult>>> call(int id);
}

class GetMessageConversationByIdImpl implements GetMessageConversationById {
  final MessageConversationRepository repository;

  GetMessageConversationByIdImpl(this.repository);

  @override
  Future<Either<Failure, List<MessageConversationResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getConversationById(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
