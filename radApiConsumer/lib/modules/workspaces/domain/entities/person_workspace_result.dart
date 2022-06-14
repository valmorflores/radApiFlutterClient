//INVITEID 	PERSONID 	WORKSPACEID 	PERSONPROFILEID
//ID 	PERSONID 	WORKSPACEID 	PAPERID 	IS_CONFIRMED 	WORKSPACEKEYVALUE
class PersonWorkspaceResult {
  int? index;
  int? id;
  int? workspaceId;
  int? paperId;
  String? name;
  bool? isConfirmed;
  String? workspaceKeyValue;

  PersonWorkspaceResult({
    this.index,
    this.id,
    this.workspaceId,
    this.paperId,
    this.name,
    this.isConfirmed,
    this.workspaceKeyValue,
  });
}
