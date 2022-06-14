import 'dart:convert';
import 'dart:ui';

import '/modules/setup/infra/models/workspace_model.dart';
import '/modules/workspaces/infra/utils/workspace_utils.dart';
import '/utils/globals.dart';
import '/utils/mgr_custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../setup_text.dart';
import '../setup_title.dart';

class PageYouAreInvited extends StatefulWidget {
  String invite;

  PageYouAreInvited({
    Key? key,
    this.invite = '',
  }) : super(key: key);

  @override
  _PageYouAreInvitedState createState() => _PageYouAreInvitedState();
}

const String strTitle = 'Você é um convidado';
const String strText =
    'Detectamos que vocẽ possui convites vinculados a suas contas de e-mails.\n'
    'Assim que vocẽ confirmar os seus e-mail nós iremos ativar seus ambientes de trabalho';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_Invite_re_rrcp.svg",
);

class _PageYouAreInvitedState extends State<PageYouAreInvited> {
  final dio = MgrCustomDio.withAuthentication().instance;

  @override
  Widget build(BuildContext context) {
    // testing only
    // todo: change to better concept(bloc?)
    app_invite_accepted = true;
    return _layout();
  }

  @override
  dispose() {
    Get.appUpdate();
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
        height: (MediaQuery.of(context).size.height - 200),
        width: (MediaQuery.of(context).size.width / 2) - 1,
        child: SingleChildScrollView(
            child: Container(
          height: (MediaQuery.of(context).size.height - 200),
          child: Column(
            children: [
              Expanded(flex: 1, child: Text('$strTitle')),
              Expanded(flex: 1, child: Text('$strText')),
              Expanded(
                  flex: 3,
                  child: Row(
                    children: [_useResult()],
                  ))
            ],
          ),
        )));
  }

  // Conteúdo em caixa para layout vertical
  Widget _contentBox() {
    return Container(
        height: (MediaQuery.of(context).size.height / 2) - 1,
        child: SingleChildScrollView(
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
            Row(children: [
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '${widget.invite}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onBackground),
                  )),
            ]),
            Row(
              children: [_useResult()],
            )
          ],
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

  Widget _useResult() {
    return Container();
  }
}
