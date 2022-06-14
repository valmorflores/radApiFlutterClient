import 'package:dartz/dartz.dart';
import '/modules/messages/domain/errors/errors.dart';
import '/modules/messages/domain/repositories/message_conversation_repository.dart';

mixin GetMessageConversationWithStaffId {
  Future<Either<Failure, int>> call(int id);
}

class GetMessageConversationWithStaffIdImpl
    implements GetMessageConversationWithStaffId {
  final MessageConversationRepository repository;

  GetMessageConversationWithStaffIdImpl(this.repository);

  @override
  Future<Either<Failure, int>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getStartConversationWith(id);
      return result.fold(
          (l) => left(l), (r) => r <= 0 ? left(EmptyList()) : right(r));
    });
  }
}
