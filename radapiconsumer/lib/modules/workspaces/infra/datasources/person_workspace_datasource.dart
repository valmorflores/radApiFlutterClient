import '/modules/workspaces/infra/models/person_workspace_model.dart';

abstract class PersonWorkspaceDatasource {
  Future<List<PersonWorkspaceModel>> getByPersonId(int id);
}
