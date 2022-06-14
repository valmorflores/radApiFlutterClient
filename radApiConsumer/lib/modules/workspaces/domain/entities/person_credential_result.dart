// ID 	USER_PASSWORD 	LAST_LOGIN 	PERSONID 	IS_ACTIVE
class PersonCredentialResult {
  int? index;
  int? id;
  int? lastLogin;
  bool? isActive;

  PersonCredentialResult({
    this.index,
    this.id,
    this.lastLogin,
    this.isActive,
  });
}
