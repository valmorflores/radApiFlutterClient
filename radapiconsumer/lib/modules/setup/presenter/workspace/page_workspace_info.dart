import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../setup_text.dart';
import '../setup_title.dart';

class PageWorkspaceInfo extends StatefulWidget {
  @override
  _PageWorkspaceInfoState createState() => _PageWorkspaceInfoState();
}

const String strTitle = 'Workspace';
const String strText =
    'Está quase tudo pronto para você começar a usar o aplicativo.\n'
    'Vocẽ terá um ambiente pessoal, que chamaremos de "Seu Workspace".\n'
    'Única coisa que precisa para isso é na próxima janela escolher um nome para você';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_profile_6l1l.svg",
);

class _PageWorkspaceInfoState extends State<PageWorkspaceInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _layout();
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
            )
          ],
        )));
  }

  // Conteúdo em caixa para layout vertical
  Widget _contentBox() {
    return SingleChildScrollView(
        child: Container(
            height: (MediaQuery.of(context).size.height / 2) - 100,
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
}
