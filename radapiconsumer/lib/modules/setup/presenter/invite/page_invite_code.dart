import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../setup_text.dart';
import '../setup_title.dart';

class PageInviteCode extends StatefulWidget {
  @override
  _PageInviteCodeState createState() => _PageInviteCodeState();
}

final String strTitle = 'Vocẽ tem um código de usuário?';
final String strText =
    'Caso você possua um vínculo a alguma instituição você pode usar seu código para ativar o ambiente no aplicativo.';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_authentication_fsn5.svg",
);

class _PageInviteCodeState extends State<PageInviteCode> {
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
                child: SetupTitle(title: strTitle),
              )
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
    return Container(
        height: (MediaQuery.of(context).size.height / 2) - 1,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SetupTitle(title: strTitle),
              )
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
