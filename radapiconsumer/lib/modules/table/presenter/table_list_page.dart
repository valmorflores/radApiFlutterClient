import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:radapiconsumer/modules/table/infra/models/table_model.dart';

import 'controllers/table_controller.dart';

class TableListPage extends StatelessWidget {
  TableController _tableController = Get.put(TableController());

  TableListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tabelas disponíveis'),
        ),
        body: Column(children: [
          Container(height: 600, child: Obx(() => buildListView(context))),
        ]));
  }

  Widget buildListView(BuildContext context) {
    return ListView.builder(
        itemCount: _tableController.tableList.length,
        itemBuilder: (context, index) {
          final tableData = _tableController.tableList.elementAt(index);

          return buildListTile(context, tableData);
        });
  }

  ListTile buildListTile(BuildContext context, TableModel _tableModel) {
    return ListTile(
        title: Text('_tableModel.name'),
        onTap: () {
          /*_tableController.process(saveServer);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserLoginPage(0)),
          );*/
        });
  }
}
