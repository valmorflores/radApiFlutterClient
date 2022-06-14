import 'package:dartz/dartz.dart';
import '/modules/messages/domain/entities/message_conversation_result.dart';
import '/modules/messages/domain/errors/errors.dart';
import '/modules/messages/domain/repositories/message_conversation_repository.dart';

mixin GetMessageConversationAllHeaders {
  Future<Either<Failure, List<MessageConversationResult>>> call();
}

//? @Injectable(singleton: false)
class GetActivityAllImpl implements GetMessageConversationAllHeaders {
  final MessageConversationRepository repository;

  GetActivityAllImpl(this.repository);

  @override
  Future<Either<Failure, List<MessageConversationResult>>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getConversationAllHeaders();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
