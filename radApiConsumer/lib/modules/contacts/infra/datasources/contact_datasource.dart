import '/modules/contacts/infra/models/contact_model.dart';

abstract class ContactDatasource {
  Future<List<ContactModel>> getUsers(String textSearch);
  Future<List<ContactModel>> getAll();
  Future<List<ContactModel>> getById(int id);
  Future<bool> deleteById(int id);
}
