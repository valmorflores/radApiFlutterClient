import '../../../../core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/client_controller.dart';

enum EIStatusEditField {
  fieldNeedCheck,
  fieldChecked,
  fieldNormal,
  fieldWrong,
}

class ClientAdd extends StatefulWidget {
  const ClientAdd({Key? key}) : super(key: key);

  @override
  _ClientAddState createState() => _ClientAddState();
}

class _ClientAddState extends State<ClientAdd> {
  ClientController _clientController = Get.put(ClientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (_clientController.formKey.currentState!.validate()) {
            _clientController.addData();
            Navigator.pop(context);
          } else {
            Get.snackbar('Erro de validação',
                'Existem campos importantes que não estão preenchidos corretamente');
          }
        },
      ),
      appBar: AppBar(title: Text('Nova Instituição')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _clientController.formKey,
            child: Column(
              children: [
                WidgetPageTitle(
                    title: 'Cadastro', onTap: () {}, context: context),
                SizedBox(
                  height: 40,
                ),
                _edit(
                    child: TextFormField(
                  controller: _clientController.companyController,
                  decoration: _decoration(
                      'Instituição', EIStatusEditField.fieldNeedCheck),
                  key: _clientController.companyKey,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Nome obrigatório';
                    }
                  },
                )),
                _edit(
                    child: TextFormField(
                  decoration:
                      _decoration('Endereço', EIStatusEditField.fieldNeedCheck),
                  key: _clientController.addressKey,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Nome obrigatório';
                    }
                  },
                )),
                _edit(
                    child: TextFormField(
                  decoration:
                      _decoration('Cidade', EIStatusEditField.fieldNeedCheck),
                  key: _clientController.cityKey,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Nome obrigatório';
                    }
                  },
                )),
                _edit(
                    child: TextFormField(
                  decoration:
                      _decoration('Estado', EIStatusEditField.fieldWrong),
                  key: _clientController.stateKey,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Nome obrigatório';
                    }
                  },
                )),
                _edit(
                    child: TextFormField(
                  decoration:
                      _decoration('País', EIStatusEditField.fieldChecked),
                  key: _clientController.countryKey,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Nome obrigatório';
                    }
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _edit({required Widget child}) {
    return Container(
        height: 60.0,
        padding: EdgeInsets.only(left: 20, top: 8),
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20.0,
              offset: Offset(0, 10.0),
            ),
          ],
        ),
        child: child);
  }

  _decoration(String _text, EIStatusEditField status) {
    Icon _icon = Icon(
      Icons.check,
      color: Theme.of(context).colorScheme.onBackground,
      size: 20.0,
    );

    if (status == EIStatusEditField.fieldChecked) {
      _icon = Icon(
        Icons.check_circle_rounded,
        color: Theme.of(context).colorScheme.primary.withAlpha(80),
        size: 20.0,
      );
    } else if (status == EIStatusEditField.fieldNeedCheck) {
      _icon = Icon(
        Icons.check,
        color: Theme.of(context).colorScheme.onBackground,
        size: 20.0,
      );
    } else if (status == EIStatusEditField.fieldWrong) {
      _icon = Icon(
        Icons.close,
        color: Colors.red,
        size: 20.0,
      );
    }

    return InputDecoration(
      suffixIcon: _icon,
      border: InputBorder.none,
      hintText: _text,
    );
  }
}



/*
"data": [
        {
            "userid": 5,
            "company": "WS SISTEMAS DE GESTAO LTDA",
            "vat": "",
            "phonenumber": "51981954698",
            "country": 0,
            "city": "VIAMÃO",
            "zip": "94.515-180",
            "state": "RS",
            "address": "TV. SAO JORGE, 191<br />\r\nVIAMÃO",
            "website": "www.criasis.com.br",
            "datecreated": "2019-01-26",
            "active": 1,
            "leadid": null,
            "billing_street": "",
            "billing_city": "",
            "billing_state": "",
            "billing_zip": "",
            "billing_country": 0,
            "shipping_street": "",
            "shipping_city": "",
            "shipping_state": "",
            "shipping_zip": "",
            "shipping_country": 0,
            "longitude": null,
            "latitude": null,
            "default_language": null,
            "default_currency": 0,
            "show_primary_contact": 0,
            "stripe_id": null,
            "registration_confirmed": 1,
            "addedfrom": 1,
            "last_change": null
        }
    ],
    "message": "Client (Id=5)",
    "records": 1
}

*/