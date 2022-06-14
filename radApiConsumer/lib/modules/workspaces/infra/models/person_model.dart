import '/modules/workspaces/domain/entities/person_credential_result.dart';
import '/modules/workspaces/domain/entities/person_email_result.dart';
import '/modules/workspaces/domain/entities/person_invite_result.dart';
import '/modules/workspaces/domain/entities/person_result.dart';
import '/modules/workspaces/domain/entities/person_token_result.dart';
import '/modules/workspaces/domain/entities/person_workspace_result.dart';

class PersonModel extends PersonResult {
  int? index;
  int? id;
  String? alias;
  String? name;
  bool? active;
  int? firstlogintimestamp;
  List<PersonEmailResult>? emails;
  List<PersonInviteResult>? invites;
  List<PersonWorkspaceResult>? workspaces;
  List<PersonTokenResult>? tokens;
  List<PersonCredentialResult>? credentials;

  PersonModel({
    this.index,
    this.id,
    this.alias,
    this.name,
    this.active,
    this.firstlogintimestamp,
    this.emails,
    this.invites,
    this.workspaces,
    this.tokens,
    this.credentials,
  });

  PersonModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    id = json['id'];
    alias = json['alias'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['index'] = this.index;
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['name'] = this.name;
    return data;
  }
}
