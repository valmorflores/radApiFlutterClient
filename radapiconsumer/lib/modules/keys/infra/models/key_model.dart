import '/modules/keys/domain/entities/key_result.dart';

class KeyModel extends KeyResult {
  int? index;
  int? id;
  int? personid;
  int? workspaceid;
  int? paperid;
  bool? isConfirmed;
  String? workspacekeyvalue;

  KeyModel(
      {this.index,
      this.id,
      this.personid,
      this.workspaceid,
      this.paperid,
      this.isConfirmed,
      this.workspacekeyvalue});

  KeyModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    id = json['id'];
    personid = json['personid'];
    workspaceid = json['workspaceid'];
    paperid = json['paperid'];
    isConfirmed = (json['is_confirmed'] == '1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['index'] = this.index;
    data['id'] = this.id;
    data['personid'] = this.personid;
    data['workspaceid'] = this.workspaceid;
    data['paperid'] = this.paperid;
    data['is_confirmed'] = this.isConfirmed! ? '1' : '0';
    return data;
  }
}
