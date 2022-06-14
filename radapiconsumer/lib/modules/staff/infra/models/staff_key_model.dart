import '/modules/staff/domain/entities/staff_key_result.dart';

class StaffKeyModel extends StaffKeyResult {
  int? id;
  int? staffId;
  int? tokenId;
  String? keyvalue;
  bool? active;

  StaffKeyModel({
    this.id,
    this.staffId,
    this.tokenId,
    this.keyvalue,
    this.active,
  });

  StaffKeyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffId = json['staffid'];
    tokenId = json['token_id'];
    keyvalue = json['keyvalue'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['staffid'] = staffId;
    data['token_id'] = tokenId;
    data['keyvalue'] = keyvalue;
    data['active'] = (active! ? '1' : '0');
    return data;
  }
}
