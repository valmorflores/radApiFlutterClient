class ProfileResult {
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

  ProfileResult(
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
      this.timestamp});
}
