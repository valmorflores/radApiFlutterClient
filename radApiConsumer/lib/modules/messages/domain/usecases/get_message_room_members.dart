import 'package:dartz/dartz.dart';
import '/modules/messages/domain/entities/message_conversation_members_result.dart';
import '/modules/messages/domain/errors/errors.dart';
import '/modules/messages/domain/repositories/message_room_repository.dart';

mixin GetMessageRoomMembers {
  Future<Either<Failure, List<MessageConversationMembersResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetMessageRoomMembersImpl implements GetMessageRoomMembers {
  final MessageRoomRepository repository;

  GetMessageRoomMembersImpl(this.repository);

  @override
  Future<Either<Failure, List<MessageConversationMembersResult>>> call(
      int id) async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getMembersByRoom(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
