import 'dart:ui';

import '/modules/setup/infra/models/device_model.dart';
import '/modules/setup/infra/models/setup_install_vars.dart';
import '/utils/progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/modules/setup/external/api/mgr_device_repository.dart';

import '../setup_text.dart';
import '../setup_title.dart';

class PageFirstEmailConfirmation extends StatefulWidget {
  final String email;

  const PageFirstEmailConfirmation({Key? key, required this.email})
      : super(key: key);

  @override
  _PageFirstEmailConfirmationState createState() =>
      _PageFirstEmailConfirmationState();
}

final String strTitle = 'Sua confirmação';
final String strText =
    'Acesse seu e-mail e coloque seu código de confirmação para que possamos validar a instalação.';
final String strConfirmated =
    'Parabéns sua confirmação de e-mail está correta e você já pode avançar nas confirgurações a seguir';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_Envelope_re_f5j4.svg",
);

class _PageFirstEmailConfirmationState
    extends State<PageFirstEmailConfirmation> {
  var _formKey = GlobalKey<FormState>();
  var _theInputKey = "";
  var _lclose = false;
  var _isValidating = false;
  DeviceModel device = DeviceModel();
  MgrDeviceRepository _deviceRepository = MgrDeviceRepository();
  TextEditingController fieldEmailController = TextEditingController();

  @override
  initState() {
    debugPrint('e-mail:' + widget.email);
    if (widget.email == '') {
      debugPrint('Empty e-mail. Please verify...');
    } else {
      setup_app_email = widget.email;
      getDevice();
    }
  }

  getDevice() async {
    device = await _deviceRepository.install(widget.email);
    setup_app_device = device;
    if (device.alias == '') {
      debugPrint('Empty alias. Please verify...');
    }
    var confirmation = await _deviceRepository.getConfirmationViaEmail(device);
    debugPrint(confirmation.toString());
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
                child: SetupTitle(title: strTitle),
              )
            ]),
            _isValidating ? CircularProgressIndicator() : Container(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: device.is_confirmated
                  ? SetupText(text: strConfirmated)
                  : SetupText(text: strText),
            ),
            Text('$setup_app_email'),
            _getConfirmation(),
            _isValidating || device.is_confirmated
                ? Container()
                : _sendEmailCode(),
          ],
        )));
  }

  Widget _sendEmailCode() {
    return MaterialButton(
      child: Text(
        'Reenviar o e-mail de confirmação',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        //repositoryDevice
        _deviceRepository.getConfirmationViaEmail(device);
      },
    );
  }

  Widget _getConfirmation() {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: device.is_confirmated
                        ? Container(
                            child: Text('E-mail validado e confirmado'),
                          )
                        : _isValidating
                            ? Container(child: Text('Validando código...'))
                            : TextFormField(
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                                controller: fieldEmailController,
                                decoration: InputDecoration(
                                    labelText: '',
                                    hintText: '',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                onChanged: (value) async {
                                  if (value.length == 6) {
                                    setState(() {
                                      _isValidating = true;
                                    });
                                    debugPrint(
                                        'Load repository method to send code ' +
                                            value);
                                    device.code = value;
                                    bool response = await _deviceRepository
                                        .sendConfirmationCode(device);
                                    debugPrint('Ok, 1');
                                    debugPrint(response.toString());
                                    if (response) {
                                      device.is_confirmated = true;
                                      setup_app_device = device;
                                    }
                                    setState(() {
                                      _isValidating = false;
                                    });
                                  }
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Insira seu e-mail';
                                  } else {
                                    _theInputKey = value;
                                  }
                                }),
                  ),
                ])));
  }

  // Conteúdo em caixa para layout vertical
  Widget _contentBox() {
    return Container(
        height: (MediaQuery.of(context).size.height / 2) - 100,
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
            _getConfirmation()
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
    return Container(child: Column(children: [_contentBox()]));
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
