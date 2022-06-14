import '/global/repositories/login_repository.dart';
import '/modules/setup/presenter/install/page_install_user_code.dart';
import '/utils/globals.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';

import '../setup_const.dart';
import '../setup_main.dart';

class SystemInstallOptions extends StatefulWidget {
  @override
  _SystemInstallOptionsState createState() => _SystemInstallOptionsState();
}

class _SystemInstallOptionsState extends State<SystemInstallOptions> {
  var _formKey = GlobalKey<FormState>();
  var _theInputKey = "";
  var _lclose = false;
  TextEditingController keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bem vindo'),
        ),
        body: Column(
          children: [
            WidgetPageTitle(
              title: 'Modos de instalação',
              context: context,
              onTap: () {},
            ).render(),
            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 30.0, 12.0, 0.0),
                  child: Container(),
                ),
              ),
            ]),
            Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                    'Selecione o modo que você deseja inicar o aplicativo neste dispositivo. Para continuar basta escolher a opção abaixo conforme sua preferência pessoal. Caso você não tenha vinculo institucional algum e seja a primeira vez que vocẽ acessa o sistema, mais abaixo você pode selecionar a opção para obter mais informações sobre o sistema.\n')),
            Card(
              child: ListTile(
                title: Text(
                  'Instalar usando uma chave',
                ),
                leading: Icon(Icons.vpn_key),
                subtitle: Text('Autenticação automática neste dispositivo'),
                onTap: () {
                  _navigateAndInstall(context: context);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Sempre autenticar"),
                leading: Icon(Icons.perm_identity_outlined),
                subtitle: Text(
                  'Autenticação manual: e-mail e senha',
                ),
                onTap: () {
                  debugPrint('Autenticação sempre via user e senha');
                },
              ),
            ),
          ],
        ));
  }

  _navigateAndInstall({BuildContext? context}) async {
    final result = await Navigator.push(
      context!,
      MaterialPageRoute(
          builder: (context) => SetupMain(start: STEP_INSTALL_CODE_INFO)),
    );

    if (result != "") {
      setState(() async {
        await LoginRepository().setUserKey(result);
        isInstalled = true;
      });
    }
  }
}
