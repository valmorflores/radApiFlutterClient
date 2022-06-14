import 'person_email_result.dart';
import 'person_credential_result.dart';
import 'person_invite_result.dart';
import 'person_token_result.dart';
import 'person_workspace_result.dart';

class PersonResult {
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

  PersonResult({
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
}
