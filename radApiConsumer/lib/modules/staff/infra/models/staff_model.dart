import '/modules/staff/domain/entities/staff_result.dart';

class StaffModel extends StaffResult {
  int? staffid;
  String? email;
  String? firstname;
  String? lastname;
  String? facebook;
  String? linkedin;
  String? phonenumber;
  String? skype;
  String? password;
  String? datecreated;
  String? profileImage;
  String? lastIp;
  String? lastLogin;
  String? lastActivity;
  String? lastPasswordChange;
  String? newPassKey;
  String? newPassKeyRequested;
  int? admin;
  int? role;
  int? active;
  String? defaultLanguage;
  String? direction;
  String? mediaPathSlug;
  int? isNotStaff;
  double? hourlyRate;
  String? twoFactorAuthEnabled;
  String? twoFactorAuthCode;
  String? twoFactorAuthCodeRequested;
  String? emailSignature;
  String? lastLoginTime;
  String? lastActivityTime;
  int? lastActiveTime;

  StaffModel(
      {this.staffid,
      this.email,
      this.firstname,
      this.lastname,
      this.facebook,
      this.linkedin,
      this.phonenumber,
      this.skype,
      this.password,
      this.datecreated,
      this.profileImage,
      this.lastIp,
      this.lastLogin,
      this.lastActivity,
      this.lastPasswordChange,
      this.newPassKey,
      this.newPassKeyRequested,
      this.admin,
      this.role,
      this.active,
      this.defaultLanguage,
      this.direction,
      this.mediaPathSlug,
      this.isNotStaff,
      this.hourlyRate,
      this.twoFactorAuthEnabled,
      this.twoFactorAuthCode,
      this.twoFactorAuthCodeRequested,
      this.emailSignature,
      this.lastLoginTime,
      this.lastActivityTime,
      this.lastActiveTime});

  StaffModel.fromJson(Map<String, dynamic> json) {
    staffid = json['staffid'] ?? 0;
    email = json['email'] ?? '';
    firstname = json['firstname'] ?? '';
    lastname = json['lastname'] ?? '';
    facebook = json['facebook'] ?? '';
    linkedin = json['linkedin'] ?? '';
    phonenumber = json['phonenumber'] ?? '';
    skype = json['skype'] ?? '';
    password = json['password'] ?? '';
    datecreated = json['datecreated'] ?? '';
    profileImage = json['profile_image'] ?? '';
    lastIp = json['last_ip'] ?? '';
    lastLogin = json['last_login'] ?? '';
    lastActivity = json['last_activity'] ?? '';
    lastPasswordChange = json['last_password_change'] ?? '';
    newPassKey = json['new_pass_key'] ?? '';
    newPassKeyRequested = json['new_pass_key_requested'] ?? '';
    admin = json['admin'] ?? 0;
    role = json['role'] ?? 0;
    active = json['active'] ?? 1;
    defaultLanguage = json['default_language'] ?? '';
    direction = json['direction'] ?? '';
    mediaPathSlug = json['media_path_slug'] ?? '';
    isNotStaff = json['is_not_staff'] ?? 0;
    if (json['hourly_rate'] == "0.00") {
      hourlyRate = 0;
    } else if (json['hourly_rate'] != '') {
      hourlyRate = double.parse(json['hourly_rate']);
    } else {
      hourlyRate = json['hourly_rate'] ?? 0;
    }

    twoFactorAuthEnabled = json['two_factor_auth_enabled'] ?? '0';
    twoFactorAuthCode = json['two_factor_auth_code'] ?? '';
    twoFactorAuthCodeRequested = json['two_factor_auth_code_requested'] ?? '';
    emailSignature = json['email_signature'] ?? '';
    lastLoginTime = json['last_login_time'] ?? '';
    lastActivityTime = json['last_activity_time'] ?? '';
    lastActiveTime = json['last_active_time'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['staffid'] = this.staffid;
    data['email'] = this.email;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['facebook'] = this.facebook;
    data['linkedin'] = this.linkedin;
    data['phonenumber'] = this.phonenumber;
    data['skype'] = this.skype;
    data['password'] = this.password;
    data['datecreated'] = this.datecreated;
    data['profile_image'] = this.profileImage;
    data['last_ip'] = this.lastIp;
    data['last_login'] = this.lastLogin;
    data['last_activity'] = this.lastActivity;
    data['last_password_change'] = this.lastPasswordChange;
    data['new_pass_key'] = this.newPassKey;
    data['new_pass_key_requested'] = this.newPassKeyRequested;
    data['admin'] = this.admin;
    data['role'] = this.role;
    data['active'] = this.active;
    data['default_language'] = this.defaultLanguage;
    data['direction'] = this.direction;
    data['media_path_slug'] = this.mediaPathSlug;
    data['is_not_staff'] = this.isNotStaff;
    data['hourly_rate'] = this.hourlyRate;
    data['two_factor_auth_enabled'] = this.twoFactorAuthEnabled;
    data['two_factor_auth_code'] = this.twoFactorAuthCode;
    data['two_factor_auth_code_requested'] = this.twoFactorAuthCodeRequested;
    data['email_signature'] = this.emailSignature;
    data['last_login_time'] = this.lastLoginTime;
    data['last_activity_time'] = this.lastActivityTime;
    data['last_active_time'] = this.lastActiveTime;
    return data;
  }
}
