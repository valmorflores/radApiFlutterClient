class SyncModel {
  int id;
  String table;
  int index;
  bool isSync;
  int timestamp;
  int lasttry;
  String message;

  SyncModel({
    required this.id,
    required this.table,
    required this.index,
    required this.isSync,
    required this.timestamp,
    required this.lasttry,
    required this.message,
  });
}
