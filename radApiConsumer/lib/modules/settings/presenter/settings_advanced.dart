import 'dart:io';

import '/core/ui/layout/my_layout.dart';
import '/global/repositories/login_repository.dart';
import '/modules/settings/presenter/settings_advanced_help_assistent.dart';
import '/modules/setup/infra/models/setup_install_vars.dart';
import '/modules/setup/setup_load.dart';
import '/utils/datetime_util.dart';
import '/utils/globals.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes.dart';

class SettingsAdvancedHome extends StatefulWidget {
  @override
  _SettingsAdvancedHomeState createState() => _SettingsAdvancedHomeState();
}

class _SettingsAdvancedHomeState extends State<SettingsAdvancedHome> {
  late String _last_validation;
  late String _last_validation_local;
  late String _last_validation_date;
  late String _is_valid;
  late String _is_active;
  late String _key;
  late String _device_alias;
  bool lRemove = false;

  @override
  initState() {
    super.initState();
  }

  Future loadinfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _last_validation = (await prefs.getString('last_validation')) ?? '';
    _last_validation_local =
        (await prefs.getString('last_validation_local')) ?? '0';
    _key = (await prefs.getString('myuserkey')) ?? '0';
    _is_valid = (await prefs.getString('key_' + _key + '_is_valid')) ?? '0';
    _is_active = (await prefs.getString('key_' + _key + '_is_active')) ?? '0';
    if (_last_validation != null) {
      _last_validation_date =
          await DateTimeUtil.readTimestamp(int.parse(_last_validation));
    } else {
      _last_validation_date = '0';
    }
    _device_alias = setup_app_device!.alias;
    return true;
  }

  Widget _error(snapshot) {
    return Column(children: [
      WidgetPageTitle(
        title: 'Sistema & dispositivo',
        context: context,
        onTap: () {},
        workspace: '',
      ).render(),
      Container(
        width: double.infinity,
        color: Colors.amber,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Erro', style: TextStyle(color: Colors.black))),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Text(
                'Erro ao carregar as informações técnicas do aplicativo. Provavelmente você não autenticou sua chave de acesso ou a mesma está inativa.')),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Text(
                'Informação técnica do erro: ' + snapshot.error.toString())),
      ),
      _removeBtn()
    ]);
  }

  Widget _data(snapshot) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(children: [
          WidgetPageTitle(
            title: 'Sistema & dispositivo',
            context: context,
            onTap: () {},
          ).render(),
          SettingsAdvancedHelpAssistent(),
          Card(
            child: ListTile(
              title: Text('Chave pessoal'),
              subtitle: Text('${_key}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Dispositivo'),
              subtitle: Text('$_device_alias'),
              onTap: () {
                setState(() {});
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Registro válido'),
              subtitle: Text('${_is_valid}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Validação'),
              subtitle: Text('${_last_validation}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Última validação'),
              subtitle: Text('${_last_validation_date}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Última validação local'),
              subtitle: Text('${_last_validation_local}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Registro Ativo'),
              subtitle: Text('${_is_active}'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Mapa de URLs'),
            subtitle: Text('Caminhos do workspace'),
            onTap: () {
              setState(() {
                Navigator.pushNamed(context, Routes.urls);
              });
            },
          ),
          _removeBtn(),
        ]));
  }

  Widget _removeBtn() {
    if (!lRemove) {
      return ListTile(
          leading: const Icon(Icons.warning_outlined),
          title: Text(
            'Remover as configurações',
          ),
          subtitle: Text(
              'Seus dados e configurações pessoais serão apagados deste dispositivo'),
          onTap: () {
            setState(() {
              _removeBtnDo();
            });
          });
    } else {
      return Container();
    }
  }

  _removeBtnDo() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Wrap(children: [
                Container(
                  height: 20,
                ),
                const ListTile(
                  leading: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.warning_sharp, color: Colors.white),
                  ),
                  title: Text(
                    '\nConfirma a exclusão?\n',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Ao confirmar, os dados pessoais serão apagados deste dispositivo e a seguir o aplicativo será finalizado para conclusão.',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: Row(children: [
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: const Text(
                            'Apagar os dados',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await _clearAll();
                            exit(0);
                          }),
                    ),
                  ]),
                ),
                Container(
                  height: 20,
                ),
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return MyLayout(
      child: Scaffold(
          appBar: AppBar(title: Text('Configurações Avançadas')),
          body: SingleChildScrollView(
              child: Column(children: [
            FutureBuilder(
                future: loadinfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _error(snapshot);
                  } else if (snapshot.hasData) {
                    return _data(snapshot);
                  } else {
                    return Container();
                  }
                }),
          ]))),
    );
  }

  Future<void> _clearAll() async {
    debugPrint('f0207 - Remover configurações..');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('f0207 - Limpando variaveis [globals]...');
    app_selected_workspace_name = '';
    app_workspace_name = '';
    debugPrint('f0207 - Removendo dados do dispositivo...');
    SetupLoad().clearAppState();
    debugPrint('f0207 - Remover demais configurações..');
    await prefs.clear();
    debugPrint('f0207 - Removendo userKey...');
    await LoginRepository().removeUserKey();
    return;
  }
}
