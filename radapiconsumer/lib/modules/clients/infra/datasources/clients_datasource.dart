import '../../../../modules/clients/infra/models/client_model.dart';

abstract class ClientsDatasource {
  Future<List<ClientModel>> searchText(String textSearch);
  Future<List<ClientModel>> getAll();
  Future<List<ClientModel>> getById(int id);
  Future<List<ClientModel>> clientAdd(ClientModel client);
  Future<List<ClientModel>> updateById(ClientModel clientModel);
  Future<bool> deleteClientById(int id);
}
