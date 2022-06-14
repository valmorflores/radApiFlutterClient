import '../../domain/entities/user_login_result.dart';

class UserLoginModel extends UserLoginResult {
  int? id;
  int? staffId;
  String? token;
  bool? active;

  UserLoginModel({
    this.id,
    this.staffId,
    this.token,
    this.active,
  });

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffId = json['staffid'];
    token = json['token'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['staffid'] = staffId;
    data['token'] = token;
    data['active'] = (active! ? '1' : '0');
    return data;
  }
}
