//import 'dart:ffi';

import '../../../../modules/clients/infra/models/client_model.dart';
import '../../../../global/resources/local_db/db/local_clients_hive_methods.dart';
import 'package:meta/meta.dart';

class LocalClientRepository {
  static var dbObject;
  static bool? isHive;

  static init({isHive}) {
    dbObject = isHive ? LocalClientHiveMethods() : null;
    dbObject.init();
  }

  static addClient(ClientModel clientModel) => dbObject.addClient(clientModel);

  static deleteClient(int clientId) => dbObject.deleteClient(clientId);

  static getClients() => dbObject.getClients();

  static close() => dbObject.close();
}
