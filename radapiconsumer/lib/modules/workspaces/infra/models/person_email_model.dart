import '/modules/workspaces/domain/entities/person_email_result.dart';

class PersonEmailModel extends PersonEmailResult {
  String? email;
  String? password;

  PersonEmailModel({
    this.email,
    this.password,
  });
}
