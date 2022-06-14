import 'dart:io';

import '/core/constants/ktables.dart';
import '/core/controllers/application/application_controller.dart';
import '/core/widgets/_widget_need_refresh_error.dart';
import '/modules/clients/domain/const/clients_constants.dart';
import '/modules/clients/domain/entities/client_result.dart';
import '/modules/clients/domain/repositories/client_repository.dart';
import '/modules/clients/domain/usecases/get_client_all.dart';
import '/modules/clients/external/api/eiapi_clients_datasource.dart';
import '/modules/clients/external/db/eidb_clients_datasource.dart';
import '/modules/clients/infra/datasources/clients_datasource.dart';
import '/modules/clients/infra/models/client_model.dart';
import '/modules/clients/infra/repositories/client_repository_impl.dart';
import '/modules/clients/presenter/client/controllers/client_controller.dart';
import '/modules/clients/presenter/client/states/clients_state.dart';
import '/utils/globals.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/modules/clients/presenter/client/client_detail.dart';
import '/utils/wks_custom_dio.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'client_home_bloc.dart';

class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  final dio = WksCustomDio.withAuthentication().instance;
  ApplicationController _applicationController = Get.find();
  ClientController _clientController = Get.put(ClientController());
  late ClientsDatasource datasource;
  late ClientRepository repository;
  late GetClientAll search;
  late ClientHomeBloc bloc; //var searchBloc = SearchBloc();
  late GlobalKey refreshKey;

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    super.initState();
    _setToLocal();
    _getdbLocalOrRemote();
  }

  // to get Remote informations
  _setToRemote() async {
    datasource = EIAPIClientsDatasource(dio);
    repository = ClientRepositoryImpl(datasource);
    search = GetClientAllImpl(repository);
    bloc = ClientHomeBloc(search);
  }

  // to local get
  _setToLocal() async {
    datasource = EIDBClientsDatasource();
    repository = ClientRepositoryImpl(datasource);
    search = GetClientAllImpl(repository);
    bloc = ClientHomeBloc(search);
  }

  _getdbLocalOrRemote() async {
    debugPrint('f8401 - Getting local or remote');
    var dbTable =
        app_selected_workspace_name + kWorkspaceTblSeparator + kTblClients;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.containsKey(dbTable);
    if (result != null) if (result) {
      // Exists local data
      debugPrint('f8401 - local found: ' + dbTable);
      await _setToLocal();
      bloc.add(1);
      setState(() {});
      return true;
    } else {
      // datasource remote
      debugPrint(
          'f8401 - Set to remote option. local records not found:' + dbTable);
      await _setToRemote();
      bloc.add(1);
      setState(() {});
      return false;
    }
  }

  Future<Null> refreshList() async {
    // Setting to remote
    await _setToRemote();
    bloc.add(1);
    setState(() {});
    await Future.delayed(Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await refreshList();
      },
      child: Column(
        children: [
          Obx(() {
            debugPrint(
                'f7777 - ClientsHome: Refresh need: ${_applicationController.count.toString()}');
            bloc.add(1);
            return Container();
          }),
          ((kIsWeb) || Platform.isLinux || Platform.isWindows)
              ? WidgetPageTitle(
                      title: 'Instituições',
                      onTap: () {
                        refreshList();
                      },
                      context: context)
                  .render()
              : Container(),
          StreamBuilder(
              stream: bloc.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  debugPrint('f8404 - Opa! Uma info na stream CLIENT-HOME...');
                  final state = bloc.state;
                  if (state is StartState) {
                    return Center(child: Text(''));
                  } else if (state is ErrorState) {
                    return WidgetNeedRefreshError(
                      title: state.error.toString(),
                      workspace: app_selected_workspace_name,
                      onTap: () {
                        refreshList();
                      },
                      context: context,
                    );
                  } else if (state is LoadingState) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: progressBar(context),
                    );
                  } else {
                    final list = (state as SuccessState).list;
                    debugPrint(
                        'f8404 - Size of data = ' + list.length.toString());
                    return Expanded(
                        child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (_, index) {
                              ClientResult item = list[index];
                              return Card(
                                  child: ListTile(
                                title: Text(item.company ?? ''),
                                subtitle: Text(item.city ?? ''),
                                onTap: () async {
                                  _clientController
                                      .loadClient(item.userid ?? 0);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ClientDetail(id: item.userid!)),
                                  );
                                },
                              ));
                            }));
                  }
                }
                return Container();
              }),
        ],
      ),
    );
  }
}
