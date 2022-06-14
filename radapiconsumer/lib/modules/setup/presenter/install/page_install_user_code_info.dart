import 'dart:ui';

import '/modules/setup/external/api/mgr_device_repository.dart';
import '/modules/setup/external/api/mgr_workspace_repository.dart';
import '/modules/setup/infra/models/device_model.dart';
import '/modules/setup/infra/models/setup_install_vars.dart';
import '/modules/setup/presenter/install/page_install_user_code_info_add_bloc.dart';
import '/modules/setup/presenter/install/page_install_user_code_info_add_key_bloc.dart';
import '/modules/setup/presenter/states/setup_staff_get_state.dart';
import '/modules/setup/presenter/states/setup_staff_key_state.dart' as keyState;
import '/modules/setup/presenter/util/setup_util.dart';
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
import '/utils/progress_bar/progress_bar.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../setup_text.dart';
import '../setup_title.dart';
import 'page_install_user_code_info_bloc.dart';

class PageInstallUserCodeInfo extends StatefulWidget {
  @override
  _PageInstallUserCodeInfoState createState() =>
      _PageInstallUserCodeInfoState();
}

const String strTitle = 'Chave';
const String strText =
    'Na opção a seguir será feita a solicitação ou criação automática de uma\n'
    'chave para você ter acesso a todos os recursos disponíveis neste workspace\n'
    'Caso vocẽ possua uma chave específica, pode usá-la preenchendo a seguir.\n';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_Security_on_re_e491.svg",
);

class _PageInstallUserCodeInfoState extends State<PageInstallUserCodeInfo> {
  var _panel = <Widget>[];
  late String _keyValue;
  DeviceModel device = DeviceModel();
  MgrDeviceRepository _deviceRepository = MgrDeviceRepository();
  final dio = WksCustomDio.withAuthentication().instance;
  late StaffRepository repository;
  late StaffDatasource datasource;
  late StaffKeyDatasource staffKeyDatasource;
  late StaffKeyRepository staffKeyRepository;

  late GetMe search;
  late AddStaff addStaff;
  late AddStaffKey addStaffKey;
  late PageInstallUserCodeInfoBloc bloc; //var searchBloc = SearchBloc();
  late PageInstallUserCodeInfoAddBloc blocAdd;
  late PageInstallUserCodeInfoAddKeyBloc blocKeyAdd;
  late GlobalKey refreshKey;

  @override
  void initState() {
    debugPrint('f3782 - initState starting');
    datasource = EIAPIStaffDatasource(dio);
    repository = StaffRepositoryImpl(datasource);
    search = GetMeImpl(repository);
    bloc = PageInstallUserCodeInfoBloc(search);
    // addStaff
    addStaff = AddStaffImpl(repository);
    blocAdd = PageInstallUserCodeInfoAddBloc(addStaff);

    staffKeyDatasource = EIAPIStaffKeyDatasource(dio);
    staffKeyRepository = StaffKeyRepositoryImpl(staffKeyDatasource);
    addStaffKey = AddStaffKeyImpl(staffKeyRepository);
    blocKeyAdd = PageInstallUserCodeInfoAddKeyBloc(addStaffKey);
    // bloc default (getMe)
    bloc.add('0');
    super.initState();
    debugPrint('f3782 - initState done');
    // Aciona criação de chave no Workspace Manager
    createKey();
  }

  createKey() async {
    debugPrint('f7292 - Getting new key for workspace');
    device = setup_app_device!;
    String response = await _deviceRepository.createKey(device);
    if (response != '') {
      _keyValue = response;
    }
    debugPrint('f7292 - response:' + response);
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
          final state = blocKeyAdd.state;
          if (state is keyState.StartState) {
            return Center(child: Text(''));
          } else if (state is keyState.ErrorState) {
            debugPrint('f5025 - Erro do status');
            return Column(children: [
              Center(child: Text('Erro ao adicionar chave')),
            ]);
          } else if (state is keyState.LoadingState) {
            return Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator());
          } else {
            final List<StaffKeyModel> list =
                (state as keyState.SuccessState).list as List<StaffKeyModel>;
            debugPrint('f5025 - Size = ' + list.length.toString());
            return Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      StaffKeyModel item = list[index];
                      return Card(
                          child: ListTile(
                        trailing: Icon(Icons.check),
                        title: Text('${item.keyvalue} / ${item.staffId}'),
                        subtitle: Text('${item.id.toString()}'),
                        onTap: () {
                          debugPrint(
                              'f5025 - resultado de blocKeyAdd:keyState');
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
            StaffModel me = StaffModel(
                email: email,
                password: 'first1283ouoiu837121',
                firstname: 'Primeiro Nome',
                lastname: 'Último nome');
            debugPrint('f8825 - user:' + me.toJson().toString());
            blocAdd.add(me);

            _panel.add(_userAddInfo());
            return Center(
                child: Text('Criação de usuário: ' + state.error.toString()));
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
                      } else {
                        return Container();
                      }
                      /*if ((index + 1 >= list.length) && (i == 0)) {
                        debugPrint(
                            'f8025 - Limite atingido e nenhum registro encontrado');
                        return Card(
                            child: ListTile(
                          trailing: Icon(Icons.close),
                          title: Text('Registro de usuário não localizado'),
                          subtitle: Text('Verifique com administração'),
                          onTap: () {},
                        ));
                      }*/
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

  Widget _userAddInfo() {
    debugPrint('f8744 - 0');
    return StreamBuilder(
      stream: blocAdd.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final state = blocAdd.state;
          if (state is StartState) {
            return Center(child: Text(''));
          } else if (state is ErrorState) {
            String email = SetupUtil().setupEmail();
            // Aciona a criação de chave (Key)
            return Center(child: Text('Usuario:' + state.error.toString()));
          } else if (state is LoadingState) {
            return Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator());
          } else {
            late StaffModel _item = StaffModel();
            final list = (state as SuccessState).list as List<StaffModel>;
            debugPrint('f8744 - Size = ' + list.length.toString());
            // First user
            if (list.length <= 0) {
              // Fail getting user
              return Container(child: Text('Usuário não registrado'));
            } else {
              // Key basic data (staffid) for add
              // first, seeker in list
              int _staffid = -1;

              if (setup_app_device!.email.length > 4) {
                for (var element in list) {
                  if (element.email == setup_app_device!.email) {
                    _staffid = element.staffid ?? _staffid;
                    _item = element;
                  }
                }
              }
              //

              if (_staffid <= 0) {
                return Wrap(
                  children: [
                    Text('Impossível localizar o usuário'),
                    Text('Vá em perfil e refaça sua validação')
                  ],
                );
              } else {
                StaffKeyModel key = StaffKeyModel(
                    id: 0, staffId: _staffid, keyvalue: _keyValue);

                // Aciona a criação de chave (KEY)
                // Starting key add
                blocKeyAdd.add(key);
                // Show user data
                _panel.add(_serverKeyAddInfo());
                _panel.add(_userkey());
                String name = '';
                if (_item.firstname == null) {
                  name = 'USO PESSOAL';
                } else {
                  name = '${_item.firstname} ${_item.lastname}';
                }
                return Container(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 0),
                    child: Container(
                      height: 200,
                      child: Expanded(
                        child: Card(
                          child: ListTile(
                            trailing: Icon(_item.active == '1'
                                ? Icons.check
                                : Icons.close),
                            title: Text('${_item.staffid.toString()} - $name'),
                            subtitle: Text('${_item.email}'),
                            onTap: () {
                              debugPrint('f8744 - teste');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
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
