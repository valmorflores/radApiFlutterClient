import 'dart:io';

import '../../../../modules/clients/infra/models/client_model.dart';
import '../../../../global/resources/local_db/interface/local_clients_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class LocalClientHiveMethods implements LocalClientInterface {
  String _hive_clients_box = 'clients_box';

  @override
  init() async {
    debugPrint('Hive/ClientMethods -> init');
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path as String);
  }

  @override
  addClient(ClientModel clientModel) async {
    debugPrint('Hive/ClientMethods -> addClient');
    var box = await Hive.openBox(_hive_clients_box);
    var client_to_map = clientModel.toJson();
    int idAdd = await box.add(client_to_map);
    return idAdd;
  }

  @override
  close() {
    debugPrint('Hive/ClientMethods -> close');
  }

  @override
  deleteClient(int clientId) {
    debugPrint('Hive/ClientMethods -> deleteCLient');
  }

  @override
  Future<List<ClientModel>> getClients() {
    // TODO: implement getClients
    throw UnimplementedError();
  }
}
