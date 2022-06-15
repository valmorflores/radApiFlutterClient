import 'dart:io';
import 'package:radapiconsumer/modules/connection/presenter/add_connection/add_connection_page.dart';
import 'package:radapiconsumer/modules/table/presenter/table_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../user/presenter/user_login/user_login_page.dart';
import '../controllers/connection_controller.dart';
import '/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListConnectionPage extends StatelessWidget {
  ConnectionController _connectionController = Get.put(ConnectionController());

  ListConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(height: 600, child: Obx(() => buildListView(context))),
        FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddConnectionPage(0)),
            );
          },
          child: Icon(Icons.add),
        ),
      ]),
    );
  }

/**
 * 
 
Container(
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
                              child: ListView(children: [
                                SizedBox(
                                  height: 12,
                                ),
                                ListTile(
                                  title: Text(
                                    'Lista de conexões',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    'Selecione abaixo a conexão que deseja administrar.',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(children: [
                                    const Spacer(),
                                    FloatingActionButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.add),
                                    )
                                  ]),
                                )
                              ])))
                    ]))

 */

  Widget buildListView(BuildContext context) {
    return ListView.builder(
        itemCount: _connectionController.listServers.length,
        itemBuilder: (context, index) {
          final saveServer = _connectionController.listServers.elementAt(index);

          return buildListTile(context, saveServer);
        });
  }

  ListTile buildListTile(BuildContext context, SaveServer saveServer) {
    return ListTile(
        leading: Icon(Icons.storage),
        tileColor: saveServer.working
            ? Color.fromARGB(255, 156, 193, 242)
            : Color.fromARGB(255, 129, 222, 214),
        title: Text(saveServer.name),
        subtitle: Text(saveServer.url),
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token') ?? '';
          _connectionController.process(saveServer);
          if (token == '') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserLoginPage(0)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TableListPage()),
            );
          }
        });
  }
}
