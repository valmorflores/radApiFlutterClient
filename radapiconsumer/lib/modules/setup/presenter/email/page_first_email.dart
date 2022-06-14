import 'dart:ui';

import '/modules/setup/infra/models/setup_install_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../setup_text.dart';
import '../setup_title.dart';

class PageFirstEmail extends StatefulWidget {
  @override
  _PageFirstEmailState createState() => _PageFirstEmailState();
}

final String strTitle = 'Seu melhor e-mail pessoal';
final String strText =
    'Para que possamos fazer os vínculos necessários, precisamos de seu e-mail';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_Envelope_re_f5j4.svg",
);

class _PageFirstEmailState extends State<PageFirstEmail> {
  var _formKey = GlobalKey<FormState>();
  var _theInputKey = "";
  var _lclose = false;
  TextEditingController fieldEmailController = TextEditingController();

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
            ),
            _getEmail()
          ],
        )));
  }

  Widget _getEmail() {
    return Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    controller: fieldEmailController,
                    decoration: InputDecoration(
                        labelText: '',
                        hintText: 'email@dominio.com',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    onFieldSubmitted: (value) {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Clique em avançar para registrar')));
                        setup_app_email = fieldEmailController.text;
                      }
                    },
                    onChanged: (atext) {
                      setup_app_email = atext;
                    },
                    onEditingComplete: () {
                      setup_app_email = fieldEmailController.text;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira seu e-mail';
                      } else {
                        _theInputKey = value;
                      }
                    }),
              ),
            ]));
  }

  // Conteúdo em caixa para layout vertical
  Widget _contentBox() {
    return Container(
        height: (MediaQuery.of(context).size.height * 0.70) - 100,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SetupTitle(title: strTitle),
              )
            ]),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SetupText(text: strText),
            ),
            _getEmail(),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                'Este e-mail pode ser seu e-mail de uso pessoal. Posteriormente você poderá vincular seus e-mails comerciais também.',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
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
    return SingleChildScrollView(child: Column(children: [_contentBox()]));
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
