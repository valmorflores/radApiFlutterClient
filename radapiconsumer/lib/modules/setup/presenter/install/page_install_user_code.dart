import '/global/resources/kconstants.dart';
import '/modules/setup/external/api/mgr_device_repository.dart';
import '/modules/setup/infra/models/device_model.dart';
import '/modules/setup/infra/models/setup_install_vars.dart';
import '/modules/setup/setup_load.dart';
import '/utils/globals.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';

class PageInstallUserCode extends StatefulWidget {
  @override
  _PageInstallUserCodeState createState() => _PageInstallUserCodeState();
}

class _PageInstallUserCodeState extends State<PageInstallUserCode> {
  var _formKey = GlobalKey<FormState>();
  var _theInputKey = "";
  var _lclose = false;
  TextEditingController keyController = TextEditingController();
  DeviceModel device = DeviceModel();
  MgrDeviceRepository _deviceRepository = MgrDeviceRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createKey();
  }

  createKey() async {
    debugPrint('f7292 - Getting new key for workspace');
    device = setup_app_device!;
    String response = await _deviceRepository.createKey(device);
    if (response != '') {
      keyController.text = response;
    }
    debugPrint('f7292 - response:' + response);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                child: Center(
                  child: Text(
                    'Para iniciar o uso efetivo do aplicativo, você precisa informar o seu código de identifição gerado no sistema de gestão. Este códido pode ainda ser fornecido pela sua instituição, caso você ainda não tenha acessado o aplicativo pela internet.',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    style: TextStyle(fontSize: 24),
                    controller: keyController,
                    decoration: InputDecoration(
                        labelText: 'Chave de API',
                        hintText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Insira um código válido para continuar';
                      } else {
                        _theInputKey = value;
                      }
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      fetchForm().then((value) {
                        if (value) {
                          // Valid value
                          Navigator.of(context)
                              .pop(keyController.value.text); //
                        } else {
                          // Error
                          Widget okButton = ElevatedButton(
                            child: Text("OK"),
                            onPressed: () {
                              debugPrint('ok');
                            },
                          );
                          AlertDialog alerta = AlertDialog(
                            title: Text("Acesso negado"),
                            content: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "Este código não foi aceito pelo sistema."),
                                  TextSpan(
                                      text:
                                          "Favor verificar e tentar novamente."),
                                  TextSpan(text: "\n"),
                                  TextSpan(text: "\n"),
                                  TextSpan(text: "Seu código informado:"),
                                  TextSpan(text: "\n"),
                                  TextSpan(
                                    text:
                                        " ${keyController.value.text.toString()} ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 32,
                                      backgroundColor: Colors.amber,
                                      color: Colors.black,
                                    ),
                                  )
                                ])),
                            actions: [
                              okButton,
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alerta;
                            },
                          );
                        }
                      });
                    },
                    child: Text('Salvar chave API'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<bool> fetchForm() async {
    if (_formKey.currentState!.validate()) {}
    return true;
  }

  saveKeyToWorkspace(String key) async {
    debugPrint('f9947-> Setup saving worskapce key');
    SetupLoad setup = SetupLoad();
    String wksname = '';
    wksname = app_selected_workspace_name;
    // remove @
    if (wksname.contains('@')) {
      wksname = wksname.substring(1);
    }
    debugPrint('f9947-> Setup saving worskapce relevant informations');
    debugPrint('f9947-> ' +
        kWorkspaceCfgPre +
        '/' +
        wksname +
        '/userkey' +
        ' => ' +
        key);
    await setup.saveWksParam(wksname, 'userkey', key);
    debugPrint('f9947-> Setup saving done.');
  }
}
