import 'package:dartz/dartz.dart';
import 'package:radapiconsumer/modules/connection/domain/errors/errors.dart';
import 'package:radapiconsumer/modules/connection/domain/usecases/add_connection.dart';
import 'package:radapiconsumer/modules/connection/domain/usecases/get_connection_all.dart';
import 'package:radapiconsumer/utils/globals.dart';
import '../../domain/repositories/connection_repository.dart';
import '../../external/db/eidb_connection_datasource.dart';
import '../../infra/datasources/connection_datasource.dart';
import '../../infra/models/ConnectionModel.dart';
import '../../infra/repositories/connection_repository_impl.dart';
import '/modules/update/presenter/controllers/url_controller.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  UrlController urlController = Get.put(UrlController());

  RxInt count = 0.obs;
  RxString urlImage = ''.obs;

  late final staffList = <ConnectionModel>[].obs;

  late int selectedStaffId;

  final dio = WksCustomDio.withAuthentication().instance;

  late ConnectionDatasource datasource;
  late ConnectionRepository connectionRepository;

  late AddConnection addConnection;

  final RxList<SaveServer> listServers = <SaveServer>[].obs;

  void process(SaveServer saveServer) {
    final index =
        listServers.indexWhere((element) => element.id == saveServer.id);
    listServers
        .replaceRange(index, index + 1, [saveServer.copyWith(working: true)]);
    app_urlapi = saveServer.url;
  }

  getConnectionAll() async {
    GetConnectionAll _getConnectionImpl =
        GetConnectionAllImpl(connectionRepository);
    var result = await _getConnectionImpl.call();
    List<ConnectionModel> _listWithConnections = [];
    var list;
    try {
      list = (result as Right).value;
    } catch (e) {
      list = <ConnectionModel>[];
    }
    int i = 0;
    listServers.clear();
    list.forEach((element) {
      listServers.add(SaveServer(
          id: ++i,
          name: element.description,
          working: false,
          url: element.url));
    });
    _listWithConnections = list;
    return _listWithConnections;
  }

  doAddConnection(
      {required String connectionUrl, required String description}) async {
    var result = await _doAddConnection(connectionUrl, description);
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<ConnectionModel> _myUrlModel = info;
      _myUrlModel.forEach((element) {
        //selectedStaffId = element.staffid ?? 0;
        count++;
      });
    }
    listServers.add(SaveServer(
        id: listServers.length + 1,
        name: description,
        working: false,
        url: connectionUrl));
    update();
  }

  _doAddConnection(String _connection, String _description) async {
    debugPrint('f8004 - Connection: $_connection - $_description');
    return await addConnection.call(
        ConnectionModel(id: 1, description: _description, url: _connection));
  }

  @override
  void onInit() {
    selectedStaffId = 0;

    // Links for data get
    datasource = EIDBConnectionDatasource();
    connectionRepository = ConnectionRepositoryImpl(datasource);
    addConnection = AddConnectionImpl(connectionRepository);
    urlImage.value = '';

    var list = [];
    getConnectionAll();

    super.onInit();
  }
}

class SaveServer {
  final int id;
  final String name;
  final String url;
  final bool working;
  SaveServer(
      {required this.id,
      required this.name,
      required this.working,
      required this.url});
  SaveServer copyWith({int? id, String? name, bool? working, String? url}) {
    return SaveServer(
        id: id ?? this.id,
        name: name ?? this.name,
        working: working ?? this.working,
        url: url ?? this.url);
  }
}
