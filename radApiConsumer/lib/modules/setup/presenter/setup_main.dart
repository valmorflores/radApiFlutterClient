import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '/modules/setup/infra/models/setup_install_vars.dart';
import '/modules/setup/presenter/email/page_first_email_confirmation.dart';
import '/modules/setup/presenter/install/page_install_workspace_code.dart';
import '/modules/setup/presenter/workspace/page_workspace_info.dart';

import '../../../routes.dart';
import '../setup_load.dart';
import 'email/page_first_email.dart';
import 'email/page_more_emails.dart';
import 'end/page_finished.dart';
import 'install/page_install_user_code.dart';
import 'install/page_install_user_code_info.dart';
import 'invite/page_invite_code.dart';
import 'invite/page_you_are_invited.dart';
import 'setup_const.dart';
import 'setup_nav_btn.dart';
import 'user/page_user.dart';
import 'user/page_user_info.dart';
import 'welcome/page_welcome.dart';
import 'workspace/page_workspace.dart';

/*

Esta paǵina é responsável pela orquestração
da implantação do sistema em um novo dispositivo.
Aqui ela aciona as demais páginas do setup inicial
na ordem que desejarmos que seja feita, bem como, 
é responsável pelos botões de avanço e pelo indicador
de progresso deste processo.

*/

class SetupMain extends StatefulWidget {
  String start;
  String params;

  SetupMain({
    Key? key,
    this.start = '',
    this.params = '',
  }) : super(key: key);

  @override
  _SetupMainState createState() => _SetupMainState();
}

class _SetupMainState extends State<SetupMain> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar: AppBar(title: Text('Title')),
        body: SafeArea(
          child: WillPopScope(
            onWillPop: () async =>
                !await _navigatorKey.currentState!.maybePop(),
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case STEP_START:
                    return MaterialPageRoute(
                        builder: (context) => FormStepStartPage(
                              start: widget.start,
                            ));
                    break;
                  case STEP_FIRST_EMAIL:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepFirstEmail());
                    break;
                  case STEP_VALIDATE_FIRST_EMAIL:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepValidateFirstEmail());
                    break;
                  case STEP_MORE_EMAILS:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepMoreEmail());
                    break;
                  case STEP_YOU_ARE_INVITED:
                    return CupertinoPageRoute(
                        builder: (context) =>
                            FormStepYouAreInvited(invite: widget.params));
                    break;
                  case STEP_INVITE_CODE:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepInviteCode());
                    break;
                  case STEP_WORKSPACE_INFO:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepWorkspaceInfo());
                    break;
                  case STEP_WORKSPACE:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepWorkspace());
                    break;
                  case STEP_FINAL:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepFinal());
                    break;
                  case STEP_INSTALL_CODE_INFO:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepInstallUserCodeInfo());
                    break;
                  case STEP_INSTALL_USER_INFO:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepUserInfo());
                    break;
                  case STEP_INSTALL_USER:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepUser());
                    break;
                  case STEP_INSTALL_CODE:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepInstallUserCode());
                    break;
                  case STEP_INSTALL_CODE_WORKSPACE:
                    return CupertinoPageRoute(
                        builder: (context) => FormStepInstallWorkspaceCode());
                    break;
                  case STEP_CLOSE:
                    Navigator.of(context).pop();
                    return CupertinoPageRoute(
                      builder: (context) => FormStepNone(),
                    );
                    break;
                }
                // otherwise
                return MaterialPageRoute(
                    builder: (context) => FormStepStartPage(
                          start: widget.start,
                        ));
              },
            ),
          ),
        ),
      ),
    );
  }
}

_closeBtn(context) {
  return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    IconButton(
      iconSize: 64,
      color: Colors.white24,
      icon: const Icon(Icons.close),
      tooltip: 'Fechar',
      onPressed: () {
        Navigator.pushNamed(context, STEP_CLOSE);
      },
    ),
  ]);
}

class FormStepStartPage extends StatelessWidget {
  String start;

  FormStepStartPage({
    Key? key,
    this.start = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.pink,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: PageWelcome()),
                Container(
                    height: 100,
                    child: SetupNavBtn(
                        text: 'Avançar',
                        onPressed: () {
                          if (start != '') {
                            Navigator.pushNamed(context, start);
                          } else {
                            Navigator.pushNamed(context, STEP_FIRST_EMAIL);
                          }
                        })),
              ],
            ),
          ),
          _closeBtn(context),
        ],
      ),
    );
  }
}

class FormStepValidateFirstEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageFirstEmailConfirmation(
              email: setup_app_email,
            ),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  if (setup_app_device!.is_confirmated) {
                    Navigator.pushNamed(context, STEP_FINAL);
                  } else {
                    Navigator.pushNamed(context, STEP_VALIDATE_FIRST_EMAIL);
                  }
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

_isValidEmail(String email) {
  return email.isNotEmpty;
}

class FormStepFirstEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: PageFirstEmail(),
            ),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  if (_isValidEmail(setup_app_email)) {
                    Navigator.pushNamed(context, STEP_VALIDATE_FIRST_EMAIL);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Preencha com um e-mail válido para continuar')));
                  }
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

class FormStepMoreEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageMoreEmail(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_YOU_ARE_INVITED);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

class FormStepYouAreInvited extends StatelessWidget {
  String invite;

  FormStepYouAreInvited({
    Key? key,
    this.invite = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height - 200,
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageYouAreInvited(invite: invite),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_CLOSE);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

class FormStepInviteCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageInviteCode(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_WORKSPACE_INFO);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

class FormStepInstallWorkspaceCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageInstallWorkspaceCode(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_FINAL);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

class FormStepWorkspaceInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageWorkspaceInfo(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_WORKSPACE);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

//PageInstallUserCodeInfo
class FormStepInstallUserCodeInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageInstallUserCodeInfo(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_INSTALL_CODE);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

//PageInstallUserCode
class FormStepInstallUserCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageInstallUserCode(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_FINAL);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

//PageInstallUserInfo
class FormStepUserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageUserInfo(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_INSTALL_USER);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

//PageUser
class FormStepUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageUser(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_FINAL);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

class FormStepWorkspace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageWorkspace(),
            SetupNavBtn(
                text: 'Avançar',
                onPressed: () {
                  Navigator.pushNamed(context, STEP_FINAL);
                }),
          ],
        ),
      ),
      _closeBtn(context)
    ]);
  }
}

// To prevent return of Route with null error
// The onGenerateRoute callback must never return null, unless an onUnknownRoute
// callback is provided as well. See another solution
// (by Valmor)
class FormStepNone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
    );
  }
}

class FormStepFinal extends StatefulWidget {
  @override
  _FormStepFinalState createState() => _FormStepFinalState();
}

class _FormStepFinalState extends State<FormStepFinal> {
  @override
  void initState() {
    super.initState();
    // Sempre que chega ao STEP final salva o setup atual,
    // antes mesmo de montar a tela, pois, os dados definitivamente
    // precisam estar salvos para que na próxima inicialização do
    // aplicativo já consiga carregar através do inicio da aplicação
    //
    // A importância disso neste momento é que o aplicativo pode
    // ser fechado sem necessariamente fazer todas as etapas de configuração
    // de uma só vez. Significa que pode-se:
    //
    // registrar um e-mail
    // validar e-mail
    // definir um workspace
    // adicionar um workspace convite
    // etc. onde o unico requisito é que o e-mail esteja validado.
    //
    saveSetupApp();
  }

  // Carrega informações iniciais (setup deste device)
  saveSetupApp() async {
    debugPrint('SetupLoad: Creating instance');
    SetupLoad setupLoad = SetupLoad();
    debugPrint('SetupLoad: Saving actual infrmations');
    await setupLoad.saveAppState();
    debugPrint('SetupLoad: Saving done');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PageFinished(),
          SetupNavBtn(
              text: 'Usar o aplicativo',
              onPressed: () {
                // Go home
                setState(() {
                  Navigator.pushNamed(context, STEP_CLOSE);
                });
              }),
        ],
      ),
    );
  }
}
