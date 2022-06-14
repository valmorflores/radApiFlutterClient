class MessageRoomListModel {
  String title;
  String subtitle;
  String time;
  String lastPartial;
  int cid;
  int user1;
  int user2;
  bool isContact;
  String type;

  MessageRoomListModel(
      {required this.title,
      required this.subtitle,
      required this.time,
      required this.lastPartial,
      required this.cid,
      required this.user1,
      required this.user2,
      required this.isContact,
      required this.type});
}
