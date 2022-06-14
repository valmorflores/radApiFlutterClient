//ID 	PERSONID 	EMAIL 	IS_ROOT 	IS_CONFIRMED
class PersonEmailResult {
  int? index;
  int? id;
  String? email;
  bool? isRoot;
  bool? isConfirmed;

  PersonEmailResult({
    this.index,
    this.id,
    this.email,
    this.isRoot,
    this.isConfirmed,
  });
}
