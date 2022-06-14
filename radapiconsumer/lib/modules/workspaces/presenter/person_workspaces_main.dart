import 'package:get/get.dart';

import '/modules/workspaces/domain/repositories/person_workspace_repository.dart';
import '/modules/workspaces/domain/usecases/get_workspaces_by_person_id.dart';
import '/modules/workspaces/external/api/eiapi_person_workspace_datasource.dart';
import '/modules/workspaces/infra/repositories/person_workspace_repository_impl.dart';
import '/modules/workspaces/presenter/person_workspaces_main_bloc.dart';
import '/modules/workspaces/presenter/states/person_workspace_state.dart';
import '/utils/custom_dio.dart';
import '/utils/globals.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes.dart';

class PersonWorkspacesMain extends StatefulWidget {
  @override
  _PersonWorkspacesMainState createState() => _PersonWorkspacesMainState();
}

class _PersonWorkspacesMainState extends State<PersonWorkspacesMain> {
  //class PersonWorkspacesMain extends StatelessWidget {
  final dio = CustomDio.withAuthentication().instance;

  late PersonWorkspacesMainBloc bloc;
  late GetWorkspacesByPersonId search;
  late PersonWorkspaceRepository repository;
  late EIAPIPersonWorkspaceDatasource datasource;
  late String _name;
  late String _email;
  late SharedPreferences _prefs;
  List<int> selectedItems = [];

  @override
  initState() {
    datasource = EIAPIPersonWorkspaceDatasource(dio);
    repository = PersonWorkspaceRepositoryImpl(datasource);
    search = GetWorkspacesByPersonIdImpl(repository);
    bloc = PersonWorkspacesMainBloc(search);
    getProprietary();
    bloc.add(1);
  }

  getProprietary() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = _prefs.getString('_proprietary_email')!;
      _name = _prefs.getString('_proprietary_name')!;
    });
  }

  setProprietary() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('_proprietary_email', _email);
    await _prefs.setString('_proprietary_name', _name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Workspaces'),
        ),
        body: Column(
          children: [
            WidgetPageTitle(
              title: 'Selecione o workspace desejado',
              context: context,
              workspace: app_selected_workspace_name,
              onTap: () {},
            ),
            _name != ''
                ? Card(
                    child: ListTile(
                      title: Text(
                        '${_name}',
                      ),
                      leading: Icon(Icons.perm_identity_outlined),
                      subtitle: Text('$_email'),
                    ),
                  )
                : Container(),
            _data(),
          ],
        ));
  }

  Widget _data() {
    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Opa! Uma info na stream Person_workspaces-MAIN...');
            final state = bloc.state;
            if (state is StartState) {
              return Center(child: Text(''));
            } else if (state is ErrorState) {
              return Center(
                  child: Text('Erro ao executar:' + state.error.toString()));
            } else if (state is LoadingState) {
              return Center(
                child: progressBar(context),
              );
            } else {
              final list = (state as SuccessState);

              var items = list.personWorkspaces;

              setProprietary();
              debugPrint('Size = ' + items.length.toString());
              return Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 290,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: items.length,
                      itemBuilder: (_, id) {
                        final item = items[id];
                        return ListTile(
                          trailing: Icon(Icons.home),
                          selected: selectedItems.indexOf(item.id!) >= 0,
                          title: Text(
                            '${item.name}',
                          ),
                          subtitle: Text('${item.id.toString()}'),
                          onLongPress: () {
                            //_showMenu();
                            if (selectedItems.indexOf(item.id!) >= 0) {
                              _itemremove(item.id!);
                            } else {
                              _itemadd(item.id!);
                            }
                          },
                          onTap: () {
                            debugPrint('Acessando ...');
                            debugPrint(item.id.toString());
                            app_userkey = item.workspaceKeyValue!;

                            // todo: valmor, corrigir
                            // temporario com esse if para testes apenas
                            // futuro será assim: app_urlapi = item.urlapi

                            // personal:valmor
                            if (item.id == 1) {
                              app_urlapi =
                                  'https://criativa.app/work/servers/sei1/gestorequipes/api/v1';
                              app_workspace_name = 'valmor';
                              app_selected_workspace_name = '@valmor';
                            }
                            // cosems.rs
                            if (item.id == 2) {
                              app_urlapi =
                                  'https://cosems.com/gestorequipes/api/v1';
                              app_workspace_name = '';
                              app_selected_workspace_name = 'cosems.rs';
                            }
                            // ws
                            if (item.id == 3) {
                              app_urlapi =
                                  'https://criativa.app/work/servers/sei2021ws/api/v1';
                              app_workspace_name = '';
                              app_selected_workspace_name = 'ws';
                            }
                            setState(() {
                              debugPrint(
                                  'Apply forceAppUpdate via Get to refresh all windows...');
                              Get.forceAppUpdate();
                            });
                            Navigator.pop(context);
                            Navigator.of(context)
                                .pushNamed(Routes.wkspace_login);
                          },
                        );
                      }),
                ),
              );
            }
          } else {
            return Container();
          }
        });
  }

  _itemadd(int i) async {
    setState(() {
      selectedItems.add(i);
    });
  }

  _itemremove(int i) async {
    setState(() {
      selectedItems.remove(i);
    });
  }
}
