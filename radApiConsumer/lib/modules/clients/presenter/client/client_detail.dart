import 'dart:io';

import '../../../../core/widgets/_widget_dialog_confirm_remove.dart';
import '../../../../modules/clients/infra/models/client_model.dart';
import '../../../../modules/contacts/infra/models/contact_model.dart';
import '../../../../modules/contacts/presenter/contact_detail_home.dart';
import '../../../../modules/clients/external/api/direct_clients_repository.dart';
import '../../../../modules/contacts/external/api/direct_contacts_repository.dart';
import '../../../../utils/phonecall_util.dart';
import '../../../../utils/progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'client_detail_help_assistent.dart';
import 'client_edit.dart';
import 'controllers/client_controller.dart';

// ignore: must_be_immutable
class ClientDetail extends StatefulWidget {
  int id;

  ClientDetail({required this.id});

  @override
  _ClientDetailState createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail> {
  late DirectClientRepository _clientRepository;
  late DirectContactRepository _contactRepository;
  late Future<List<ContactModel>> contacts;
  late Future<ClientModel> client;
  late Future<void> _launched;
  String _phone = '';
  PageController pageDetailController = PageController(initialPage: 0);
  ClientController _clientController = Get.put(ClientController());

  @override
  initState() {
    _getData();
  }

  _getData() async {
    _contactRepository = DirectContactRepository();
    _clientRepository = DirectClientRepository();
    client = _clientRepository.getById(widget.id);
    contacts = _contactRepository.getByClientId(widget.id);
    _clientController.loadClient(widget.id);
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void _showModalMenu() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 320,
            child: _menu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(14),
                    topRight: const Radius.circular(14))),
          );
        });
  }

  Widget _menu() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Editar'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClientEdit(id: widget.id)),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Adicionar um contato'),
          onTap: () {
            // load data
          },
        ),
        ListTile(
          leading: Icon(Icons.home_outlined),
          title: Text('Atividades'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.inbox),
          title: Text('Adicionar uma atividade'),
          onTap: () {
            // load data
          },
        ),
        ListTile(
            leading: Icon(Icons.delete),
            title: Text('Excluir registro'),
            onTap: () async {
              var result = await _removeBtnDo();
              if (result != null && result) {
                Navigator.pop(context);
              }
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instituição'),
        actions: [
          InkWell(
              onTap: () async {
                var result = await _removeBtnDo();
                //debugPrint('$result');
                if (result != null && result) {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.delete),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu),
        onPressed: () {
          _showModalMenu();
        },
      ),
      body: PageView(
        controller: pageDetailController,
        children: [page1(), page2()],
      ),
    );
  }

  Widget page1() {
    return Obx(() => SingleChildScrollView(
          child: Center(
              child: Column(children: [
            Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
                child: Text("")), //'' + widget.id.toString()
            FutureBuilder(
                future: this.client,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Transform(
                        transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
                        child: progressBar(context),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Text('Error: {$snapshot.error}'),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    ClientModel _clientModel = (snapshot.data as ClientModel);
                    return Column(children: [
                      ClientDetailHelpAssistent(),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                          child: ListTile(
                              title: Text(
                                '${_clientController.companyController.text}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(_clientModel.city!))),
                      Card(
                          child: ListTile(
                              leading: Icon(Icons.perm_identity),
                              title: Text(
                                  '${_clientController.vatController.text}'),
                              onTap: () {})),
                      Card(
                        child: ListTile(
                            leading: Icon(Icons.map),
                            title: Text(
                                '${_clientController.addressController.text}'),
                            subtitle: Text(_clientModel.city!)),
                      ),
                      Card(
                          child: ListTile(
                              leading: Icon(Icons.share),
                              title: Text(
                                  '${_clientController.phonenumberController.text}'),
                              onTap: () {
                                setState(() {
                                  _phone =
                                      '${_clientController.phonenumberController.text}';
                                  _launched = _launchWhatsApp(
                                      phone: '55' + _phone, message: '');
                                });
                              })),
                      Card(
                          child: ListTile(
                              leading: Icon(Icons.phone),
                              title: Text(
                                  '${_clientController.phonenumberController.text}'),
                              onTap: () {
                                setState(() {
                                  _phone =
                                      '${_clientController.phonenumberController.text}';
                                  _launched = PhoneCallUtil()
                                      .makePhoneCall('tel:$_phone');
                                });
                              })),
                      Card(
                          child: ListTile(
                              title: Text(
                                  '${_clientController.websiteController.text}'),
                              leading: Icon(Icons.web_asset),
                              onTap: () {
                                setState(() {
                                  //'https://' +
                                  String toLaunch =
                                      '${_clientController.websiteController.text}';
                                  _launched = _launchInBrowser(toLaunch);
                                });
                              }
                              //
                              )),
                    ]);
                  }
                  return Container();
                }),
            Text('Refreshing data/count: ${_clientController.count}',
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.background)),
          ])),
        ));
  }

  Widget page2() {
    return Column(
      children: [
        Container(
            color: Theme.of(context).colorScheme.primary,
            height: 50,
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                //debugPrint('reload button pressed');
                //_reload();
              },
              child: Text(
                "Contatos",
                style: TextStyle(color: Colors.white),
              ),
            )),
        FutureBuilder(
            future: this.contacts,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: progressBar(context),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Text('Error: {$snapshot.error}'),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          ContactModel item = snapshot.data[index];
                          return Card(
                              child: ListTile(
                            trailing: Icon(
                                item.active == '1' ? Icons.check : Icons.close),
                            title: Text('${item.firstname} ${item.lastname}'),
                            subtitle: Text('${item.email}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ContactDetailHome(id: item.id ?? 0)),
                              );
                            },
                          ));
                        }));
              }
              return Container();
            }),
      ],
    );
  }

  _removeBtnDo() async {
    return await showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return WidgetDialogConfirmRemove(onTap: () async {
            _clientController.delete(widget.id);
            Navigator.of(context).pop(true);
          });
        });
  }
}
