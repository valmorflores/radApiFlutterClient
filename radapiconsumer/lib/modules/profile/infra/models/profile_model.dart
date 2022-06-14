import '../../../../modules/profile/domain/entities/profile_result.dart';

class ProfileModel extends ProfileResult {
  int? index;
  int? id;
  int? userId;
  int? clientId;
  String? name;
  String? scopes;
  String? token;
  String? refreshToken;
  bool? revoked;
  String? createdAt;
  String? updatedAt;
  String? expiresAtDate;
  String? expiresAtTime;
  int? staffid;
  String? email;
  String? emailVerifiedAt;
  bool? rememberToken;
  int? timestamp;
  String? firstname;
  String? lastname;
  String? profileImage;

  ProfileModel(
      {this.index,
      this.id,
      this.userId,
      this.clientId,
      this.name,
      this.scopes,
      this.token,
      this.refreshToken,
      this.revoked,
      this.createdAt,
      this.updatedAt,
      this.expiresAtDate,
      this.expiresAtTime,
      this.staffid,
      this.email,
      this.emailVerifiedAt,
      this.rememberToken,
      this.timestamp,
      this.firstname,
      this.lastname,
      this.profileImage});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    id = json['id'];
    staffid = json['staffid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    userId = json['user_id'];
    clientId = json['client_id'];
    name = json['name'];
    scopes = json['scopes'];
    token = json['token'];
    refreshToken = json['refresh_token'];
    revoked = json['revoked'] == 1;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expiresAtDate = json['expires_at_date'];
    expiresAtTime = json['expires_at_time'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    rememberToken = json['remember_token'] == 1;
    timestamp = json['timestamp'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['index'] = this.index;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['client_id'] = this.clientId;
    data['name'] = this.name;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['scopes'] = this.scopes;
    data['token'] = this.token;
    data['refresh_token'] = this.refreshToken;
    data['revoked'] = this.revoked;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['expires_at_date'] = this.expiresAtDate;
    data['expires_at_time'] = this.expiresAtTime;
    data['staffid'] = this.staffid;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['remember_token'] = this.rememberToken;
    data['timestamp'] = this.timestamp;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
