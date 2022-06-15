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
        Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Obx(() => buildListView(context))),
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

  Widget buildListView(BuildContext context) {
    return ListView.builder(
        itemCount: _connectionController.listServers.length,
        itemBuilder: (context, index) {
          final saveServer = _connectionController.listServers.elementAt(index);

          return buildListTile(context, saveServer);
        });
  }

  Widget _offsetPopup(String serverName) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Excluir token e refazer login",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        onSelected: (value) async {
          print("Removing $value $serverName");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token$serverName');
          _connectionController.getConnectionAll();
        },
        icon: Icon(Icons.token),
        offset: Offset(0, 30),
      );

  Future<String> _trailingHasToken(String serverName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token$serverName') ?? '';
    if (token == '') {
      return '';
    } else {
      return token;
    }
  }

  ListTile buildListTile(BuildContext context, SaveServer saveServer) {
    return ListTile(
        leading: Icon(Icons.storage),
        trailing: FutureBuilder(
          future: _trailingHasToken(saveServer.name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != '') {
                return _offsetPopup(saveServer.name); //Icon(Icons.token);
              }
            }
            return Container(
              width: 10,
              height: 10,
            );
          },
        ),
        tileColor: saveServer.working
            ? Color.fromARGB(255, 156, 193, 242)
            : Color.fromARGB(255, 129, 222, 214),
        title: Text(saveServer.name),
        subtitle: Text(saveServer.url),
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          app_selected_workspace_name = saveServer.name;
          var token =
              prefs.getString('token$app_selected_workspace_name') ?? '';
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
