import '/modules/messages/domain/entities/message_room_result.dart';

class MessageRoomModel extends MessageRoomResult {
  int? id;
  String? title;
  String? type;
  List? membersId;
  List? contactsId;
  int user1;
  int user2;
  bool isContact;

  MessageRoomModel(
      {this.id,
      this.title,
      this.membersId,
      this.contactsId,
      required this.type,
      required this.user1,
      required this.user2,
      required this.isContact});
}
