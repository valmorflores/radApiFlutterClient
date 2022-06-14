import 'dart:io';

import '../controllers/connection_controller.dart';
import '/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddConnectionPage extends StatelessWidget {
  ConnectionController _connectionController = Get.put(ConnectionController());
  TextEditingController _urlController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final int staffid;
  AddConnectionPage(this.staffid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _descriptionController.text = '';
    _urlController.text = 'http://localhost:89/dev/radApi/public/v1';

    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height * 0.60,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              height: 200,
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Nova Conexão',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      'As informações a seguir aparecerão específicamente neste ambiente. Para cada workspace você pode se identificar como preferir.',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Descrição',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    subtitle: TextField(
                                      controller: _descriptionController,
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          size: 20.0,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Filtro',
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Url',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    subtitle: TextField(
                                      controller: _urlController,
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          size: 20.0,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Filtro',
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(children: [
                          const Spacer(),
                          FloatingActionButton(
                            onPressed: () async {
                              await _connectionController.doAddConnection(
                                connectionUrl: _urlController.text,
                                description: _descriptionController.text,
                              );
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.check),
                          )
                        ]),
                      )
                    ]))));
  }
}
