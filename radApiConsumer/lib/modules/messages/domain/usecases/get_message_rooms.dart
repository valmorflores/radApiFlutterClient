import 'package:dartz/dartz.dart';
import '/modules/messages/domain/entities/message_conversation_result.dart';
import '/modules/messages/domain/entities/message_room_result.dart';
import '/modules/messages/domain/errors/errors.dart';
import '/modules/messages/domain/repositories/message_room_repository.dart';

mixin GetMessageRooms {
  Future<Either<Failure, List<MessageRoomResult>>> call();
}

//? @Injectable(singleton: false)
class GetMessageRoomsImpl implements GetMessageRooms {
  final MessageRoomRepository repository;

  GetMessageRoomsImpl(this.repository);

  @override
  Future<Either<Failure, List<MessageRoomResult>>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getRooms();
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
