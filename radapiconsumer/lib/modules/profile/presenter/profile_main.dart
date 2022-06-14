import 'dart:io';

import '../../../../core/ui/layout/my_layout.dart';
import '../../../../global/repositories/login_repository.dart';
import '../../../../modules/keys/domain/repositories/key_repository.dart';
import '../../../../modules/keys/domain/usecases/get_by_key.dart';
import '../../../../modules/keys/external/api/eiapi_key_datasource.dart';
import '../../../../modules/keys/infra/repositories/key_repository_impl.dart';
import '../../../../modules/profile/domain/repositories/profile_repository.dart';
import '../../../../modules/profile/domain/usecases/get_details_by_id.dart';
import '../../../../modules/profile/domain/usecases/get_id_by_email.dart';
import '../../../../modules/profile/external/api/eiapi_profile_datasource.dart';
import '../../../../modules/profile/infra/models/profile_model.dart';
import '../../../../modules/profile/infra/repositories/profile_repository_impl.dart';
import '../../../../modules/profile/presenter/states/profile_state.dart'
    as profileState;
import '../../../../modules/profile/presenter/states/profile_id_state.dart'
    as profileid;
import '../../../../modules/profile/presenter/states/key_state.dart'
    as keyState;
import '../../../../modules/setup/external/api/mgr_workspace_repository.dart';
import '../../../../modules/setup/infra/models/setup_install_vars.dart';
import '../../../../modules/setup/presenter/user/page_user.dart';
import '../../../../modules/setup/presenter/user/page_user_info.dart';
import '../../../../modules/staff/domain/repositories/staff_key_repository.dart';
import '../../../../modules/staff/domain/usecases/patch_staff_key.dart';
import '../../../../modules/staff/external/api/eiapi_staff_key_datasource.dart';
import '../../../../modules/staff/infra/datasources/staff_key_datasource.dart';
import '../../../../modules/staff/infra/models/staff_key_model.dart';
import '../../../../modules/staff/infra/repositories/staff_key_repository_impl.dart';
import '../../../../modules/workspaces/infra/models/person_model.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/mgr_custom_dio.dart';
import '../../../../utils/progress_bar/progress_bar.dart';
import '../../../../utils/wks_custom_dio.dart';
import '../../../../core/widgets/_widget_page_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes.dart';
import 'key_by_key_bloc.dart';
import 'profile_id_by_email_bloc.dart';
import 'profile_main_bloc.dart';

class ProfileMain extends StatefulWidget {
  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  //class ProfileMain extends StatelessWidget {
  final dio = WksCustomDio.withAuthentication().instance;
  final dioMgr = MgrCustomDio.withAuthentication().instance;
  var _isValid = false;
  int _personId = 0;
  int _staffId = 0;
  String _name = '';
  String _email = '';

  late MgrWorkspaceRepository mgrWorkspaceRepository;
  late ProfileMainBloc bloc;
  late ProfileIdByEmailBloc blocId;
  /* key */
  late KeyByKeyBloc blocKey;
  late GetByKey searchKey;
  late KeyRepository keyRepository;
  late EIAPIKeyDatasource keyDatasource;
  /* profile */
  late GetDetailsById search;
  late ProfileRepository repository;
  late EIAPIProfileDatasource datasource;
  late SharedPreferences _prefs;
  late GetIdByEmail getIdByEmail;

  @override
  initState() {
    /* profile */
    datasource = EIAPIProfileDatasource(dio);
    repository = ProfileRepositoryImpl(datasource);
    search = GetDetailsByIdImpl(repository);
    bloc = ProfileMainBloc(search);
    getIdByEmail = GetIdByEmailImpl(repository);
    blocId = ProfileIdByEmailBloc(getIdByEmail);
    /* key */
    keyDatasource = EIAPIKeyDatasource(dioMgr);
    keyRepository = KeyRepositoryImpl(keyDatasource);
    searchKey = GetByKeyImpl(keyRepository);
    blocKey = KeyByKeyBloc(searchKey);
    /* mgrWorkspce */
    mgrWorkspaceRepository = MgrWorkspaceRepository();
    /* starting base functions */
    getProprietary();
    valid().then((value) => _isValid = value);
  }

  getProprietary() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = _prefs.getString('_proprietary_email') ?? '';
      _name = _prefs.getString('_proprietary_name') ?? '';
    });

    // get e-mail by device
    String email = setup_app_device!.email;
    if (email == '') {
      email = setup_app_device!.alias;
      email = email.substring(0, email.length - 32);
      email = email.substring(5);
    }
    debugPrint('f1425 - ' + email);
    blocId.add(email);
    blocKey.add(app_userkey);
  }

  setProprietary() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('_proprietary_email', _email);
    await _prefs.setString('_proprietary_name', _name);
  }

  Future<bool> valid() async {
    return await LoginRepository().isValidKey(app_userkey);
  }

  _emailAnalise() {
    List<Widget> response = [];
    if (setup_app_device!.email.length > 0) {
      response.add(ListTile(
        title: Text('E-mail de instalação encontrado'),
        subtitle: Text('${setup_app_device!.email}'),
        leading: Icon(Icons.check),
      ));
    } else {
      response.add(ListTile(
        title: Text('E-mail de instalação não encontrado'),
        subtitle: Text('Parece que você ainda não validou um e-mail'),
        leading: Icon(Icons.close),
      ));
    }
    return response;
  }

  _keyAnalise() {
    debugPrint('f8868 - Starting resulting streambuild...');
    return StreamBuilder(
      stream: blocKey.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          debugPrint('f8868 - progress...');
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          debugPrint('f8868 - error...');
          return Container();
        }
        if (snapshot.data != null) {
          debugPrint('f8868 - Informação: ' + snapshot.data.toString());
          final state = blocKey.state;
          if (state is keyState.StartState) {
            return Center(child: Text(''));
          } else if (state is keyState.ErrorState) {
            return ListTile(
              title: Text('Impossível validar a chave registrada'),
              subtitle: Text('${setup_app_device!.email}'),
              leading: Icon(Icons.close),
            );
          } else if (state is keyState.LoadingState) {
            return Center(
              child: progressBar(context),
            );
          } else {
            final data = (state as keyState.SuccessState).list;
            List<Widget> response = [];
            if (data.length > 1) {
              response.add(ListTile(
                  title: Text('Chave está duplicada'),
                  subtitle: Text('Substituição ou reconfiguração é necessária'),
                  leading: Icon(Icons.close)));
            } else if (data.length <= 0) {
              response.add(ListTile(
                title: Text('Código de identificação não localizado'),
                subtitle: Text('Registro no workspace incorreto'),
                leading: Icon(Icons.close),
              ));
            } else {
              if (data[0].personid == 0) {
                response.add(ListTile(
                  title: Text('Chave localizada mas, sem usuário correto'),
                  subtitle: Text('Registro de chave incompleto no workspace'),
                  leading: Icon(Icons.close),
                ));
              } else if (data[0].workspaceid == 0) {
                response.add(ListTile(
                  title: Text('Chave localizada mas, sem workspace indicado'),
                  subtitle: Text('Registro de chave incompleto no workspace'),
                  leading: Icon(Icons.close),
                ));
              }
            }
            if (response.length <= 0) {
              response.add(ListTile(
                title: Text('Chave correta no workspace'),
                subtitle: Text('Registro correto, requer análise de validade'),
                leading: Icon(Icons.check),
              ));
            }
            debugPrint('f8868 - Data: ' + data.toString());
            return Column(children: response);
          }
        } else {
          debugPrint('f8868 - dados!');
          var info = snapshot.data;
          debugPrint('f8868 - ' + info.toString());

          return ListTile(
            title: Text(info.toString()),
          );
        }
        return Container();
      },
    );
  }

  _userId() {
    debugPrint('f8868 - resulting streambuild...');
    return StreamBuilder(
      stream: blocId.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          debugPrint('f8868 - progress...');
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          debugPrint('f8868 - error...');
          return Container(
              height: 16,
              child: ListTile(title: Text('Erro ao obter Id de usuário')));
        }
        if (snapshot.data != null) {
          debugPrint('f8868 - Informação: ' + snapshot.data.toString());
          final state = blocId.state;
          if (state is profileid.StartState) {
            return Center(child: Text('Pesquisando informações...'));
          } else if (state is profileid.ErrorState) {
            return Column(children: [
              ListTile(
                title: Text('Impossível validar o usuário'),
                subtitle: Text('${setup_app_device!.email}'),
                leading: Icon(Icons.close),
              ),
              ListTile(
                leading: Icon(Icons.warning),
                title: Text('Clique aqui para criar seu usuário'),
                subtitle: Text('Esta ação irá corrigir sua instalação'),
                onTap: () async {
                  final result =
                      await Navigator.pushNamed(context, Routes.setup_user);
                },
              ),
            ]);
          } else if (state is profileid.LoadingState) {
            return Center(
              child: progressBar(context),
            );
          } else {
            final data = (state as profileid.SuccessState).id;
            _staffId = data;
            bloc.add(_staffId);
            debugPrint('f8868 - Data: ' + data.toString());
            return Column(
              children: [
                _validateComparingStaffData(_staffId),
                ListTile(
                  title: Text('Código de usuário'),
                  subtitle: Text(
                      'Registro de usuário correto no gerenciador de workspace'),
                  leading: Icon(Icons.check),
                )
              ],
            );
          }
        } else {
          debugPrint('f8868 - dados!');
          var info = snapshot.data;
          debugPrint('f8868 - ' + info.toString());
          _staffId = info;
          bloc.add(_staffId);
          return ListTile(
            title: Text(info.toString()),
          );
        }
      },
    );
  }

  _validateComparingStaffData(_staffId) {
    int _usuario = app_user.staffid ?? 0;
    return Column(
      children: [
        ListTile(
          leading: _usuario == _staffId ? Icon(Icons.check) : Icon(Icons.close),
          title: Text('Comparação de identificação de usuário'),
          subtitle: Text(
              'Código segundo servidor de workspaces: [$_staffId] / Código interno [$_usuario]'),
        ),
        if (!(_usuario == _staffId))
          ListTile(
            leading: Icon(Icons.warning),
            title: Text('Ação de correção necessária'),
            subtitle: Wrap(children: [
              Text('Clique a seguir para corrigir este problema'),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  child: Text('Corrigir',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground)),
                  onPressed: () {
                    _correctPatchKey(_staffId, app_userkey);
                  })
            ]),
          )
      ],
    );
  }

  _correctPatchKey(int _staffId, String _key) async {
    /*
    if (_key.isNotEmpty) {
      late StaffKeyDatasource _staffKeyDatasource;
      late StaffKeyRepository _staffKeyRepository;
      late PatchStaffKey _patchStaffKey;
      _staffKeyDatasource = EIAPIStaffKeyDatasource(dio);
      _staffKeyRepository = StaffKeyRepositoryImpl(_staffKeyDatasource);
      _patchStaffKey = PatchStaffKeyImpl(_staffKeyRepository);

      StaffKeyModel staffKeyModel =
          StaffKeyModel(staffId: _staffId, keyvalue: _key, active: true);
      await _patchStaffKey.call(staffKeyModel);
      Get.snackbar('Chave vinculada',
          'A chave foi vinculada a sua conta, refaça a análise de perfil para verificar se está tudo certo.');
    }
    */
  }

  _refreshAll() async {
    await getProprietary();
    bloc.add(app_user.staffid ?? 0);
    valid().then((value) => _isValid = value);
  }

  @override
  Widget build(BuildContext context) {
    return MyLayout(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Perfil'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                WidgetPageTitle(
                  title: 'Meus dados',
                  context: context,
                  onTap: () {
                    _refreshAll();
                  },
                ).render(),
                if (kIsWeb)
                  ListTile(
                    leading: Icon(Icons.login),
                    title: Text('Login do Google'),
                    subtitle: Text('Fazer login via webApp'),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                          context, Routes.login_google);
                    },
                  )
                else if (Platform.isAndroid)
                  ListTile(
                    leading: Icon(Icons.login),
                    title: Text('Login do Google'),
                    subtitle: Text('Fazer login usando uma conta do Google'),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                          context, Routes.login_google);
                    },
                  ),
                ListTile(
                  title: Text(app_selected_workspace_name == ''
                      ? 'Nenhum workspace selecionado'
                      : 'Workspace selecionado'),
                  subtitle: Text(app_selected_workspace_name == ''
                      ? 'Precisa selecionar'
                      : '$app_selected_workspace_name'),
                  leading: Icon(app_selected_workspace_name == ''
                      ? Icons.close
                      : Icons.check),
                ),
                ListTile(
                  title: Text(app_userkey == ''
                      ? 'Nenhuma chave registrada no dispositivo'
                      : 'Chave registrada'),
                  subtitle: Text(
                      app_userkey == '' ? 'Precisa registrar' : '$app_userkey'),
                  leading: Icon(app_userkey == '' ? Icons.close : Icons.check),
                ),
                ..._emailAnalise(),
                _keyAnalise(),
                _userId(),
                FutureBuilder(
                    future: valid(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == false) {
                          return Container(
                            width: double.infinity,
                            color: Colors.amber,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Text(
                                    'Chave Inválida',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: TextButton(
                                              onPressed: () {
                                                debugPrint(
                                                    'f8901 - Workspace key analises');
                                                _createWorkspaceKey();
                                              },
                                              child: Text('Analisar'))))
                                ])),
                          );
                        } else {
                          //setState(() {});
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
                _data(),
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
                Card(
                  child: ListTile(
                    title:
                        Text("${app_userkey}", style: TextStyle(fontSize: 24)),
                    leading: Icon(Icons.vpn_key),
                    subtitle: Text(
                      _isValid ? 'Chave válida' : 'Clique para analisar',
                      style: TextStyle(color: Colors.green),
                    ),
                    onLongPress: () {
                      _navigateAndInstall(context: context);
                    },
                    onTap: () {
                      setState(() {
                        valid().then((value) => _isValid = value);
                      });
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _data() {
    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Opa! Uma info na stream PROFILE-MAIN...');
            final state = bloc.state;
            if (state is profileState.StartState) {
              return Center(child: Text(''));
            } else if (state is profileState.ErrorState) {
              return ListTile(
                title: Text('Usuário inacessível neste workspace'),
                subtitle:
                    Text('Sem identificação de propriedade (Id: $_staffId)'),
                leading: Icon(Icons.close),
              );
              /*return Center(
                  child: Text('Erro ao executar:' + state.error.toString()));
              */
            } else if (state is profileState.LoadingState) {
              return Center(
                child: progressBar(context),
              );
            } else {
              final list = (state as profileState.SuccessState).list;
              var item = list[0] as ProfileModel;
              _email = '${item.email}';
              _name = '${item.firstname} ${item.lastname}';
              setProprietary();
              debugPrint('Size = ' + list.length.toString());
              return Column(children: [
                ListTile(
                  title: Text(
                    'Id',
                  ),
                  subtitle: Text('${item.staffid}'),
                  leading:
                      item.userId! > 0 ? Icon(Icons.check) : Icon(Icons.close),
                ),
                ListTile(
                  title: Text(
                    'E-mail',
                  ),
                  subtitle: Text('${item.email}'),
                  leading: item.email != null
                      ? Icon(Icons.check)
                      : Icon(Icons.close),
                ),
                ListTile(
                    title: Text(
                      'Name',
                    ),
                    subtitle: Text('${item.firstname} ${item.lastname}'),
                    leading: Icon(Icons.check)),
              ]);
            }
          } else {
            return Container(height: 5);
          }
        });
  }

  _createWorkspaceKey() async {
    // Get person for WKSMGR
    PersonModel person =
        await mgrWorkspaceRepository.getPersonByDevice(setup_app_device!);
    String workspaceName = app_workspace_name;
    // Alternative
    if (workspaceName == '') {
      workspaceName = app_selected_workspace_name;
      if (workspaceName.contains('@')) {
        workspaceName = workspaceName.substring(1);
      }
    }
    _personId = person.id!;
    debugPrint('f4708 - [Workspace Manager] workspacename: ' + workspaceName);
    // Get Keys for WKSMGR
    List<StaffKeyModel> listKeys = await mgrWorkspaceRepository
        .getMyPersonWorkspacesKeys(_personId, workspaceName);
    bool lExists = false;
    bool lActive = false;
    if (_personId <= 0) {
      debugPrint('f4708 - [Workspace Manager] PersonId não localizado');
    } else {
      debugPrint(
          'f4708 - [Workspace Manager] Analisando a existencia da chave: ' +
              app_userkey +
              ' wks: ' +
              workspaceName +
              ' personId: ' +
              _personId.toString());
      if (listKeys.length <= 0) {
        debugPrint('f4708 - [Workspace Manager] Nenhuma chave vinculada');
      }
      listKeys.forEach((element) {
        if (element.keyvalue == app_userkey) {
          lExists = true;
          //if (element.active) {
          lActive = true;
          //}
        }
      });
      // Setup userkey if don't exists
      if (app_userkey == '') {
        debugPrint('f4708 - Sem chave local registrada');
        final result = await Navigator.pushNamed(context, Routes.setup_userkey);
        return result;
      }
      // Else, setup workspace
      if (lExists && lActive) {
        // todo: Comanda a criação dentro do proprio
        // banco de dados do workspace, pois já existe e está
        // ativo no banco de dados de workspace manager
        debugPrint('f4708 - [Workspace Manager] Existe o registro no : ' +
            app_userkey);
        // Acionando página de viculo de chave com a chave já criada no WKSMGR
        final result =
            await Navigator.pushNamed(context, Routes.setup_workspace_key);
        return result;
      }
    }
  }

  _navigateAndInstall({required BuildContext context}) async {
    final result = await Navigator.pushNamed(context, Routes.setup_userkey);
    final String resultKey = '$result';
    if (result != "") {
      setState(() async {
        await LoginRepository().setUserKey(resultKey);
        valid();
      });
    }
  }
}
