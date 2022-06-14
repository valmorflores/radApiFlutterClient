class StaffResult {
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

  StaffResult(
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
}
