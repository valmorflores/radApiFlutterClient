import 'dart:ui';

import '/modules/setup/external/api/mgr_device_repository.dart';
import '/modules/setup/external/api/mgr_workspace_repository.dart';
import '/modules/setup/infra/models/device_model.dart';
import '/modules/setup/infra/models/setup_install_vars.dart';
import '/modules/setup/presenter/states/setup_staff_get_state.dart';
import '/modules/setup/presenter/util/setup_util.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';
import '/modules/staff/domain/usecases/add_staff.dart';
import '/modules/staff/domain/usecases/add_staff_key.dart';
import '/modules/staff/domain/usecases/get_me.dart';
import '/modules/staff/external/api/eiapi_staff_datasource.dart';
import '/modules/staff/infra/datasources/staff_datasource.dart';
import '/modules/staff/infra/models/staff_model.dart';
import '/modules/staff/infra/repositories/staff_repository_impl.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../setup_text.dart';
import '../setup_title.dart';
import 'page_user_add_bloc.dart';
import 'page_user_get_bloc.dart';

class PageUser extends StatefulWidget {
  @override
  _PageUserState createState() => _PageUserState();
}

const String strTitle = 'Usuário';
const String strText =
    'Na opção a seguir será feita a criação automática de sua\n'
    'conta de usuário em seu ambiente de trabalho pessoal\n'
    '\n';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_Security_on_re_e491.svg",
);

class _PageUserState extends State<PageUser> {
  var _panel = <Widget>[];
  late String _keyValue;
  DeviceModel device = DeviceModel();
  MgrDeviceRepository _deviceRepository = MgrDeviceRepository();
  final dio = WksCustomDio.withAuthentication().instance;
  late StaffRepository repository;
  late StaffDatasource datasource;

  late GetMe search;
  late AddStaff addStaff;

  late PageUserGetBloc blocGet; //var searchBloc = SearchBloc();
  late PageUserAddBloc blocAdd;
  late GlobalKey refreshKey;

  @override
  void initState() {
    debugPrint('f3782 - initState starting');
    datasource = EIAPIStaffDatasource(dio);
    repository = StaffRepositoryImpl(datasource);
    search = GetMeImpl(repository);
    blocGet = PageUserGetBloc(search);
    // addStaff
    addStaff = AddStaffImpl(repository);
    blocAdd = PageUserAddBloc(addStaff);

    // bloc default (getMe)
    blocGet.add('0');
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

  Widget _userGet() {
    debugPrint('f5025 - 0');
    return StreamBuilder(
      stream: blocGet.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final state = blocGet.state;
          if (state is StartState) {
            return Center(child: Text(''));
          } else if (state is ErrorState) {
            debugPrint('f5025 - Erro do status');
            String email = SetupUtil().setupEmail();
            StaffModel me = StaffModel(
                email: email,
                password: 'first1283ouoiu837121',
                firstname: 'Primeiro Nome',
                lastname: 'Último nome');
            debugPrint('f8825 - user:' + me.toJson().toString());
            blocAdd.add(me);
            _panel.add(_userAdd());
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
              child: Stack(children: [
                ListView.builder(
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
                    }),
                _addUserIfNeed(list),
              ]),
            );
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

  Widget _addUserIfNeed(List<StaffModel> list) {
    bool _lFound = false;
    String email = SetupUtil().setupEmail();
    list.forEach((e) {
      if (e.email == email) {
        _lFound = true;
      }
    });

    if (!_lFound) {
      StaffModel me = StaffModel(
          email: email,
          password: 'first1283ouoiu837121',
          firstname: 'Primeiro Nome',
          lastname: 'Último nome');
      debugPrint('f8825 - user:' + me.toJson().toString());
      blocAdd.add(me);
      _panel.add(_userAdd());
      return ListTile(
        title: Text('Novo: ${me.email}'),
        subtitle: Text('$email'),
      );
    } else {
      return ListTile(
        title: Text('Usuário encontrado com sucesso'),
      );
    }
  }

  Widget _userAdd() {
    debugPrint('f8025 - 0');
    return StreamBuilder(
      stream: blocAdd.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final state = blocAdd.state;
          if (state is StartState) {
            return Center(child: Text('Iniciando...'));
          } else if (state is ErrorState) {
            //' + state.error.toString()
            return Center(child: Text('Criação de usuário:'));
          } else if (state is LoadingState) {
            return Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator());
          } else {
            final list = (state as SuccessState).list;
            int i = 0;
            debugPrint('f8025 - Size = ' + list.length.toString());
            return Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      StaffModel item = list[index] as StaffModel;
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

  Widget _user() {
    //TODO: put streamBuilder blocKeyAdd here
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 0),
      child: Container(
          child: Card(
              child: ListTile(
                  trailing: Icon(Icons.check),
                  title: Text('Usuário Adicionado'),
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
            _userGet(),
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
