import '/modules/profile/domain/repositories/profile_repository.dart';
import '/modules/profile/domain/usecases/get_id_by_email.dart';
import '/modules/profile/external/api/eiapi_profile_datasource.dart';
import '/modules/profile/infra/repositories/profile_repository_impl.dart';
import '/modules/setup/external/api/mgr_device_repository.dart';
import '/modules/setup/infra/models/device_model.dart';
import '/modules/setup/infra/models/setup_install_vars.dart';
import '/modules/setup/presenter/install/page_install_user_code_get_id_bloc.dart';
import '/modules/setup/presenter/install/page_install_user_code_info_add_key_bloc.dart';
import '/modules/setup/presenter/setup_main.dart';
import '/modules/setup/presenter/states/setup_staff_get_state.dart';
import '/modules/setup/presenter/states/setup_staff_get_id_state.dart'
    as stateStaffGetId;
import '/modules/staff/domain/repositories/staff_key_repository.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';
import '/modules/staff/domain/usecases/add_staff.dart';
import '/modules/staff/domain/usecases/add_staff_key.dart';
import '/modules/staff/domain/usecases/get_me.dart';
import '/modules/staff/external/api/eiapi_staff_key_datasource.dart';
import '/modules/staff/external/api/eiapi_staff_datasource.dart';
import '/modules/staff/infra/datasources/staff_datasource.dart';
import '/modules/staff/infra/datasources/staff_key_datasource.dart';
import '/modules/staff/infra/models/staff_key_model.dart';
import '/modules/staff/infra/models/staff_model.dart';
import '/modules/staff/infra/repositories/staff_key_repository_impl.dart';
import '/modules/staff/infra/repositories/staff_repository_impl.dart';
import '/routes.dart';
import '/utils/globals.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../setup_const.dart';
import '../setup_text.dart';
import '../setup_title.dart';
import 'page_install_user_code_info_bloc.dart';

class PageInstallWorkspaceCode extends StatefulWidget {
  @override
  _PageInstallWorkspaceCodeState createState() =>
      _PageInstallWorkspaceCodeState();
}

const String strTitle = 'Link de chave';
const String strText =
    'O sistema fará a seguir a ligação de seu dispositivo com seu workspace'
    'através de sua chave de conexão.\n';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_Security_on_re_e491.svg",
);

class _PageInstallWorkspaceCodeState extends State<PageInstallWorkspaceCode> {
  var _panel = <Widget>[];
  String _keyValue = app_userkey;
  late String _email;
  late int _staffId;
  DeviceModel device = DeviceModel();
  MgrDeviceRepository _deviceRepository = MgrDeviceRepository();
  final dio = WksCustomDio.withAuthentication().instance;
  late StaffRepository repository;
  late StaffDatasource datasource;
  late StaffKeyDatasource staffKeyDatasource;
  late StaffKeyRepository staffKeyRepository;

  late GetMe search;
  late AddStaffKey addStaffKey;
  late AddStaff addStaff;
  late PageInstallUserCodeInfoBloc bloc;
  late PageInstallUserCodeInfoAddKeyBloc blocKeyAdd;
  late GlobalKey refreshKey;

  late ProfileRepository repositoryProfile;
  late EIAPIProfileDatasource datasourceProfile;
  late GetIdByEmail getIdByEmail;
  late PageInstallUserCodeGetIdBloc blocUserGetId;

  @override
  void initState() {
    debugPrint('f6042 - initState starting');
    datasource = EIAPIStaffDatasource(dio);
    repository = StaffRepositoryImpl(datasource);
    search = GetMeImpl(repository);
    bloc = PageInstallUserCodeInfoBloc(search);
    staffKeyDatasource = EIAPIStaffKeyDatasource(dio);
    staffKeyRepository = StaffKeyRepositoryImpl(staffKeyDatasource);
    addStaffKey = AddStaffKeyImpl(staffKeyRepository);
    blocKeyAdd = PageInstallUserCodeInfoAddKeyBloc(addStaffKey);

    datasourceProfile = EIAPIProfileDatasource(dio);
    repositoryProfile = ProfileRepositoryImpl(datasourceProfile);
    getIdByEmail = GetIdByEmailImpl(repositoryProfile);
    blocUserGetId = PageInstallUserCodeGetIdBloc(getIdByEmail);

    _staffId = 0;
    _email = _getEmail();
    blocUserGetId.add(_email);

    // bloc default (getMe)
    bloc.add('0');
    super.initState();
    debugPrint('f6042 - initState done');
    // Aciona criação de chave no Workspace Manager
    loadKey();
  }

  String _getEmail() {
    String email = setup_app_device!.email;
    if (email == null || email == '') {
      email = setup_app_device!.alias;
      debugPrint('f8825 - ' + email);
      email = email.substring(0, email.length - 32);
      debugPrint('f8825 - ' + email);
      email = email.substring(5);
      debugPrint('f8825 - ' + email);
      //email = email.substring(5);
    }
    return email;
  }

  loadKey() async {
    _keyValue = app_userkey;
  }

  @override
  Widget build(BuildContext context) {
    return _layout();
  }

  Widget _serverKeyAddInfo() {
    debugPrint('f5025 - 0');
    return StreamBuilder(
      stream: blocKeyAdd.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final state = bloc.state;
          if (state is StartState) {
            return Center(child: Text(''));
          } else if (state is ErrorState) {
            debugPrint('f5025 - Erro do status');
            return Column(children: [
              Center(
                  child: Text('Chave adicionada com sucesso: ' +
                      state.error.toString())),
            ]);
          } else if (state is LoadingState) {
            return Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator());
          } else {
            final List<StaffModel> list =
                (state as SuccessState).list as List<StaffModel>;
            debugPrint('f5025 - Size = ' + list.length.toString());

            return Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      StaffModel item = list[index];
                      return Card(
                          child: ListTile(
                        trailing: Icon(Icons.check),
                        title: Text('${item.firstname} ${item.lastname}'),
                        subtitle: Text('${item.email}'),
                        onTap: () {
                          debugPrint('f5025 - teste');
                        },
                      ));
                    }));
          }
        } else if (!snapshot.hasData) {
          return Center(child: Center(child: Text('Analisando')));
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Text('Error: {$snapshot.error}'),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _profileInfo() {
    debugPrint('f8980 - getProfileInfo user data');
    return StreamBuilder(
      stream: blocUserGetId.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final state = blocUserGetId.state;
          if (state is stateStaffGetId.StartState) {
            return Center(child: Text('Iniciando...'));
          } else if (state is stateStaffGetId.ErrorState) {
            /// todo: review loacal for "Adicionar"
            String email = _email;
            StaffModel me = StaffModel(
                email: email, password: '', firstname: '', lastname: '');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SetupMain(
                          start: STEP_INSTALL_USER_INFO,
                        )));
            return Center(
                child: Text(
                    'Acionando criação de usuário: ' + state.error.toString()));
          } else if (state is stateStaffGetId.LoadingState) {
            return Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator());
          } else {
            final id = (state as stateStaffGetId.SuccessState).id;
            if (id > 0) {
              debugPrint('f8025 - Perfil com id: ' + id.toString());
              debugPrint('f8025 - Ligando a chave: $_keyValue');
              blocKeyAdd.add(StaffKeyModel(
                  keyvalue: _keyValue, staffId: id, active: true));
            } else {
              return Container(
                child: Text('Perfil não localizado'),
              );
            }
            return ListTile(
                trailing: Icon(Icons.check),
                title: Text('Identificação realizada: $id'),
                subtitle: Text('Usuário habilitado'));
          }
        } else if (!snapshot.hasData) {
          return Center(child: Center(child: Text('Analisando')));
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Text('Error: {$snapshot.error}'),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _serverInfo() {
    debugPrint('f8025 - 0');
    return StreamBuilder(
      stream: bloc.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final state = bloc.state;
          if (state is StartState) {
            return Center(child: Text('Iniciando...'));
          } else if (state is ErrorState) {
            /// todo: review loacal for "Adicionar"
            String email = _email;
            StaffModel me = StaffModel(
                email: email, password: '', firstname: '', lastname: '');

            /*********************
                 * 
                 * 
                 * 
                 * todo: valmor
                 * CORRIGIR URGENTE PARA PEGAR O CODIGO STAFF DO USUÁRIO
                 * 
                 * 
                 * 
                 * 
                 *  *********************/
            blocKeyAdd.add(
                StaffKeyModel(keyvalue: _keyValue, staffId: 1, active: true));
            return Center(
                child: Text(
                    'Acionando criação de usuário: ' + state.error.toString()));
          } else if (state is LoadingState) {
            return Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator());
          } else {
            final List<StaffModel> list =
                (state as SuccessState).list as List<StaffModel>;
            int i = 0;
            debugPrint('f8025 - Size = ' + list.length.toString());
            return Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      StaffModel item = list[index];
                      //debugPrint(
                      //    'f8025 - Processando item: ' + index.toString());
                      if (item.staffid != null) {
                        ++i;
                        return Card(
                            child: ListTile(
                          trailing: Icon(
                              item.active == '1' ? Icons.check : Icons.close),
                          title: Text(
                              '${item.staffid} ${item.firstname} ${item.lastname}'),
                          subtitle: Text('${item.email}'),
                          onTap: () {
                            debugPrint('f8025 - teste');
                          },
                        ));
                      } else
                        return Container();
                    }));
          }
        } else if (!snapshot.hasData) {
          return Center(child: Center(child: Text('Analisando')));
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Text('Error: {$snapshot.error}'),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _userkey() {
    //TODO: put streamBuilder blocKeyAdd here
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 0),
      child: Container(
          child: Card(
              child: ListTile(
                  trailing: Icon(Icons.check),
                  title: Text('Chave criada'),
                  subtitle: Text(_keyValue)))),
    );
  }

  // Imagem com meia largura para layout lateral
  Widget _image() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height - 100,
      child: Container(
          decoration: BoxDecoration(color: Colors.pink),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: svg,
          )),
    );
  }

  // Imagem em caixa para layout vertical
  Widget _imageBox() {
    return SizedBox(
      height: (MediaQuery.of(context).size.height / 2) - 100,
      child: Container(
          decoration: BoxDecoration(color: Colors.pink),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: svg,
          )),
    );
  }

  Widget _keyInfo() {
    return Container(
      child: Text(
          _keyValue == '' ? 'Sem chave registrada' : 'Chave: $_keyValue',
          style: TextStyle(
              fontSize: 48, color: Theme.of(context).colorScheme.onBackground)),
    );
  }

  // Conteúdo de meia largura para layout horizontal
  Widget _content() {
    return Container(
        width: (MediaQuery.of(context).size.width / 2) - 1,
        height: (MediaQuery.of(context).size.height - 200),
        child: Column(
          children: [
            Row(children: [
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SetupTitle(title: strTitle))
            ]),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SetupText(text: strText),
            ),
            _profileInfo(),
            _keyInfo(),
            _serverInfo(),
          ],
        ));
  }

  // Conteúdo em caixa para layout vertical
  Widget _contentBox() {
    _panel.add(Row(children: [
      Padding(
          padding: const EdgeInsets.all(12.0),
          child: SetupTitle(title: strTitle))
    ]));
    _panel.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: SetupText(text: strText),
    ));
    return SingleChildScrollView(
        child: Container(
            height: (MediaQuery.of(context).size.height / 2) - 1,
            child: Column(
              children: _panel,
            )));
  }

  // Seletor de layout conforme largura
  Widget _layout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _layoutViewSmall();
        } else {
          return _layoutViewLarge();
        }
      },
    );
  }

  // Em largura menor empilamento dos widgets
  // (um abaixo do outro)
  Widget _layoutViewSmall() {
    return Container(child: Column(children: [_imageBox(), _contentBox()]));
  }

  // Em largura maior coloca os widgets em row
  // (um ao lado do outro)
  Widget _layoutViewLarge() {
    return Container(
        child: Column(children: [
      Row(children: [_image(), _content()])
    ]));
  }
}
