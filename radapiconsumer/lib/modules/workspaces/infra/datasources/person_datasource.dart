import '/modules/workspaces/infra/models/person_model.dart';

abstract class PersonDatasource {
  Future<List<PersonModel>> getAll();
  Future<List<PersonModel>> getById(int id);
  Future<List<PersonModel>> getByAlias(String searchText);
  Future<List<PersonModel>> getPersons(String searchText);
  Future<PersonModel> postLogin(String email, String password);
}
