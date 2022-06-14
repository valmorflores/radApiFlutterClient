import '../../../../modules/clients/infra/models/client_model.dart';

abstract class LocalClientInterface {
  init();

  addClient(ClientModel clientModel);

  Future<List<ClientModel>> getClients();

  deleteClient(int clientId);

  close();
}
