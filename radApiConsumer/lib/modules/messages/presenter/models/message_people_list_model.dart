class MessagePeopleListModel {
  String title;
  String subtitle;
  String name;
  int id;
  String lastActivity;
  bool isContact;

  MessagePeopleListModel(
      {required this.title,
      required this.subtitle,
      required this.name,
      required this.id,
      required this.isContact,
      required this.lastActivity});
}
