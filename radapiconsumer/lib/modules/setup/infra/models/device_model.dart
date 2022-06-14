class DeviceModel {
  String id;
  String alias;
  String email;
  String code;
  bool is_waiting;
  bool is_expirated;
  bool is_confirmated;
  bool is_deleted;

  DeviceModel({
    this.id = '0',
    this.alias = '',
    this.email = '',
    this.code = '',
    this.is_waiting = false,
    this.is_expirated = false,
    this.is_confirmated = false,
    this.is_deleted = false,
  });
}
