import 'dart:io';

import '../../../../core/api/notification_api.dart';
import '../../../../core/constants/kpayload.dart';
import '../../../../core/constants/kversion.dart';
import '../../../../core/ui/layout/my_layout.dart';
import '../../../../modules/clients/infra/models/client_model.dart';
import '../../../../global/resources/local_db/repository/local_clients_repository.dart';
import '../../../../modules/settings/presenter/controllers/settings_bindings.dart';
import '../../../../modules/settings/presenter/settings_local_data.dart';
import '../../../../modules/setup/infra/models/setup_install_vars.dart';
import '../../../../routes.dart';
import '../../../../utils/datetime_util.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/progress_bar/progress_bar.dart';
import '../../../../core/widgets/_widget_page_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemHome extends StatefulWidget {
  @override
  _SystemHomeState createState() => _SystemHomeState();
}

class _SystemHomeState extends State<SystemHome> {
  late String _theme_mode;
  late String _last_validation;
  late String _last_validation_local;
  late String _version;
  bool _isDevSelected = false;
  int _clickDev = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future loadinfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _theme_mode = (await prefs.getString('theme')) ?? '0';
    _last_validation = (await prefs.getString('last_validation')) ?? '';
    _last_validation_local =
        (await prefs.getString('last_validation_local')) ?? '';
    _version = kVersion;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MyLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sobre sistema'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            FutureBuilder(
                future: loadinfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(children: [
                      WidgetPageTitle(
                        title: 'Sistema & dispositivo',
                        context: context,
                        showWorkspace: true,
                        workspace: '',
                        onTap: () {},
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.amber,
                        child: const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Erro',
                                style: TextStyle(color: Colors.black))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: const Text(
                                'Erro ao carregar as informações técnicas do aplicativo. Provavelmente você não autenticou sua chave de acesso ou a mesma está inativa.')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Text('Informação técnica do erro: ' +
                                snapshot.error.toString())),
                      ),
                    ]);
                  } else if (snapshot.hasData) {
                    return Column(children: [
                      WidgetPageTitle(
                        title: 'Sistema & dispositivo',
                        context: context,
                        workspace: '',
                        showWorkspace: true,
                        onTap: () {},
                      ).render(),
                      Card(
                        child: ListTile(
                          onLongPress: () {
                            setState(() {
                              _isDevSelected = !_isDevSelected;
                              if (kIsWeb) {
                              } else if (Platform.isAndroid) {
                                NotificationApi.showNotification(
                                    title: 'RadApi Client',
                                    body: 'Modo desenvolvedor habilitado.'
                                        'Você está no ambiente $app_selected_workspace_name',
                                    payload: kPayloadDevelopmentModeOn);
                              }
                              debugPrint(
                                  'f7777 - Modo desenvolvedor habilitado: ${_isDevSelected}');
                            });
                          },
                          onTap: () {
                            setState(() {
                              if (++_clickDev > 7) {
                                _isDevSelected = true;
                              }
                              loadinfo();
                            });
                          },
                          selected: _isDevSelected,
                          title: const Text('Versão'),
                          subtitle: Text('${_version}'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Cores '),
                          subtitle: Text('Modo (${_theme_mode})'),
                          onTap: () {
                            setState(() {
                              _nextTheme();
                            });
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Notificações'),
                          subtitle: const Text('Atalho para notificações'),
                          onTap: () {
                            setState(() {
                              Navigator.pushNamed(
                                  context, Routes.notifications);
                            });
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Convites'),
                          subtitle: const Text('Atalho para convites'),
                          onTap: () {
                            setState(() {
                              Navigator.pushNamed(context, Routes.invites);
                            });
                          },
                        ),
                      ),
                      _isDevSelected
                          ? Card(
                              child: ListTile(
                                title: const Text('Modo desenvolvedor'),
                                subtitle:
                                    const Text('Dados armazenados localmente'),
                                onTap: () {
                                  setState(() {
                                    Get.to(() => SettingsLocalData());
                                    //,
                                    //    binding: SettingsBindings());
                                  });
                                },
                              ),
                            )
                          : Container(),
                      _isDevSelected
                          ? Card(
                              child: ListTile(
                                title:
                                    const Text('Atualização de banco de dados'),
                                subtitle: const Text(
                                    'Executa atualização de banco de dados no servidor'),
                                onTap: () {
                                  /*setState(() {
                                    Get.to(() => const UpdateDatabaseServer());
                                    //,
                                    //    binding: SettingsBindings());
                                  });*/
                                },
                              ),
                            )
                          : Container(),
                      Card(
                        child: ListTile(
                          title: const Text('Configurações avançadas'),
                          subtitle: const Text(
                              'Ajuste de configurações e limpeza de informações'),
                          onTap: () {
                            setState(() {
                              Navigator.pushNamed(
                                  context, Routes.settings_advanced);
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () async {
                              debugPrint('Click! salvar registro...');
                              await LocalClientRepository.init(isHive: true);
                              var id = await LocalClientRepository.addClient(
                                  ClientModel());
                              debugPrint(id.toString());
                            },
                            child: const Text(
                              "Salvar registros localmente",
                            )),
                      ),
                    ]);
                  } else {
                    return Container(child: progressBar(context));
                  }
                })
          ]),
        ),
      ),
    );
  }

  void _nextTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _theme_mode = prefs.getString('theme')!;
    if (_theme_mode == '0') {
      await prefs.setString('theme', '1');
      ThemeMode.light;
      setState(() {
        Get.changeThemeMode(ThemeMode.light);
      });
    } else if (_theme_mode == '1') {
      await prefs.setString('theme', '2');
      setState(() {
        Get.changeThemeMode(ThemeMode.dark);
      });
    } else {
      await prefs.setString('theme', '0');
      setState(() {
        Get.changeThemeMode(ThemeMode.system);
      });
    }
    setState(() {});
  }
}
