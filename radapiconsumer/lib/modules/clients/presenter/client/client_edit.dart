import '../../../../core/widgets/_widget_form_field_default.dart';
import '../../../../modules/clients/presenter/client/controllers/client_controller.dart';
import '../../../../utils/progress_bar/progress_bar.dart';
import '../../../../core/widgets/_widget_page_title.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ClientEdit extends StatefulWidget {
  int id;

  ClientEdit({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _ClientEditState createState() => _ClientEditState();
}

class _ClientEditState extends State<ClientEdit> {
  ClientController _clientController = Get.put(ClientController());
  bool isOpen = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _clientController.loadClient(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          var validate = _clientController.formKey.currentState?.validate();
          if (validate == true) {
            _clientController.updateData();
            Navigator.pop(context);
          } else {
            Get.snackbar('Erro de validação', 'Revise os campos com aviso.');
          }
        },
      ),
      appBar: AppBar(title: Text('Editar Instituição')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Obx(
            () => Form(
              key: _clientController.formKey,
              child: Column(
                children: [
                  WidgetPageTitle(
                      title: 'Cadastro', onTap: () {}, context: context),
                  SizedBox(
                    height: 5,
                    child: Visibility(
                        child: progressBar(context),
                        visible: _clientController.isProcessing.value),
                  ),
                  Text('${_clientController.count}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background)),
                  SizedBox(
                    height: 40,
                  ),
                  _minimalData(),
                  _fundamentalsData(),
                  _shippingData(),
                  _billingData(),
                  _actionArea(),
                  Container(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _actionArea() {
    return Container(
      height: 60,
      child: Row(
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _clientController.formKey.currentState?.reset();
                });
              },
              child: Text('Limpar')),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                _clientController.isProcessing.value = true;
                _clientController.formKey.currentState!.validate();
                await Future.delayed(Duration(milliseconds: 500));
                setState(() {});
                _clientController.isProcessing.value = false;
              },
              child: Text('Validar'))
        ],
      ),
    );
  }

  _minimalData() {
    return Column(
      children: [
        WidgetFormFieldDefault(
          keyName: _clientController.companyKey,
          //initialValue: _clientController.companyController.text,
          controller: _clientController.companyController,
          text: 'Nome da instituição',
          status: _needValidation(_clientController.companyKey),
          validator: (String? value) {
            if (value == null) {
              return 'Nome obrigatório';
            }
            if (value == '') {
              return 'Nome está em branco';
            }
          },
        ),
        WidgetFormFieldDefault(
          keyName: _clientController.phonenumberKey,
          initialValue: _clientController.phonenumberController.text,
          text: 'Fone',
          status: _needValidation(_clientController.phonenumberKey),
          validator: (String? value) {
            if (value == null) {
              return 'Fone obrigatório';
            }
            if (value == '') {
              return 'Fone obrigatório';
            }
          },
        ),
        const SizedBox(height: 30)
      ],
    );
  }

  _fundamentalsData() {
    return ExpansionTile(
        maintainState: true,
        initiallyExpanded: true,
        onExpansionChanged: (isExpanded) {
          if (isExpanded) {
            //
          }
        },
        title: Text('Dados fundamentais',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        children: [
          WidgetFormFieldDefault(
            keyName: _clientController.websiteKey,
            controller: _clientController.websiteController,
            text: 'Website',
            validator: (String? value) {
              if (value == null) {
                return 'CPF/CNPJ';
              }
            },
          ),
          WidgetFormFieldDefault(
            keyName: _clientController.vatKey,
            controller: _clientController.vatController,
            text: 'CPF/CNPJ',
            status: _needValidation(_clientController.vatKey),
            validator: (String? value) {
              if (value == null) {
                return 'CPF/CNPJ';
              }
            },
          ),
          WidgetFormFieldDefault(
            keyName: _clientController.zipKey,
            controller: _clientController.zipController,
            text: 'Cep',
            validator: (String? value) {},
          ),
          WidgetFormFieldDefault(
            keyName: _clientController.addressKey,
            controller: _clientController.addressController,
            text: 'Endereço',
            status: _needValidation(_clientController.addressKey),
            validator: (String? value) {
              if (value == null) {
                return 'Nome obrigatório';
              }
            },
          ),
          WidgetFormFieldDefault(
            keyName: _clientController.cityKey,
            controller: _clientController.cityController,
            text: 'Cidade',
            validator: (String? value) {
              if (value == null) {
                return 'Cidade é obrigatório';
              }
            },
          ),
          WidgetFormFieldDefault(
            text: 'Estado',
            status: EIStatusEditField.fieldNormal,
            keyName: _clientController.stateKey,
            controller: _clientController.stateController,
            validator: (String? value) {},
          ),
          WidgetFormFieldDefault(
              enabled: false,
              text: 'País',
              status: EIStatusEditField.fieldChecked,
              controller: _clientController.countryController,
              keyName: _clientController.countryKey,
              validator: (String? value) {}),
        ]);
  }

  _shippingData() {
    return ExpansionTile(
      maintainState: true,
      initiallyExpanded: false,
      onExpansionChanged: (isExpanded) {
        if (isExpanded) {
          //
        }
      },
      title: Text('Dados de correspondência',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      children: [
        WidgetFormFieldDefault(
          keyName: _clientController.shipping_zipKey,
          initialValue: _clientController.shipping_zipController.text,
          text: 'Cep',
          validator: (String? value) {},
        ),
        WidgetFormFieldDefault(
          keyName: _clientController.shipping_streetKey,
          initialValue: _clientController.shipping_streetController.text,
          text: 'Endereço',
          status: _needValidation(_clientController.shipping_streetKey),
          validator: (String? value) {
            if (value == null) {
              return 'Nome obrigatório';
            }
          },
        ),
        WidgetFormFieldDefault(
          keyName: _clientController.shipping_cityKey,
          initialValue: _clientController.shipping_cityController.text,
          text: 'Cidade',
          validator: (String? value) {
            if (value == null) {
              return 'Cidade é obrigatório';
            }
          },
        ),
        WidgetFormFieldDefault(
          text: 'Estado',
          initialValue: _clientController.shipping_stateController.text,
          status: EIStatusEditField.fieldNormal,
          keyName: _clientController.shipping_stateKey,
          validator: (String? value) {},
        ),
        WidgetFormFieldDefault(
            text: 'País',
            status: EIStatusEditField.fieldChecked,
            initialValue: _clientController.shipping_countryController.text,
            keyName: _clientController.shipping_countryKey,
            validator: (String? value) {}),
      ],
    );
  }

  _billingData() {
    return ExpansionTile(
      maintainState: true,
      initiallyExpanded: false,
      onExpansionChanged: (isExpanded) {
        if (isExpanded) {
          //
        }
      },
      title: Text('Dados de cobrança',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      children: [
        WidgetFormFieldDefault(
          keyName: _clientController.billing_zipKey,
          initialValue: _clientController.billing_zipController.text,
          text: 'Cep',
          validator: (String? value) {},
        ),
        WidgetFormFieldDefault(
          keyName: _clientController.billing_streetKey,
          initialValue: _clientController.billing_streetController.text,
          text: 'Endereço',
          status: _needValidation(_clientController.billing_streetKey),
          validator: (String? value) {
            if (value == null) {
              return 'Nome obrigatório';
            }
          },
        ),
        WidgetFormFieldDefault(
          keyName: _clientController.billing_cityKey,
          initialValue: _clientController.billing_cityController.text,
          text: 'Cidade',
          validator: (String? value) {
            if (value == null) {
              return 'Cidade é obrigatório';
            }
          },
        ),
        WidgetFormFieldDefault(
          text: 'Estado',
          status: EIStatusEditField.fieldNormal,
          keyName: _clientController.billing_stateKey,
          initialValue: _clientController.billing_stateController.text,
          validator: (String? value) {},
        ),
        WidgetFormFieldDefault(
            text: 'País',
            status: EIStatusEditField.fieldChecked,
            keyName: _clientController.billing_countryKey,
            initialValue: _clientController.billing_countryController.text,
            validator: (String? value) {}),
      ],
    );
  }

  EIStatusEditField? _needValidation(GlobalKey<FormFieldState> _nameKey) {
    return (_nameKey.currentState == null
        ? EIStatusEditField.fieldNeedCheck
        : (!_nameKey.currentState!.isValid
            ? EIStatusEditField.fieldWrong
            : EIStatusEditField.fieldChecked));
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