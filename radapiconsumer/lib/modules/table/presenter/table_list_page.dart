import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:radapiconsumer/modules/table/infra/models/table_model.dart';

import '../../table_field/presenter/table_field_list_page.dart';
import 'controllers/table_controller.dart';

class TableListPage extends StatelessWidget {
  TableController _tableController = Get.put(TableController());

  TableListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tabelas disponíveis'),
          actions: <Widget>[
            FutureBuilder(
              future: _tableController.getTableAllData(),
              builder: (context, snapshot) => Container(
                width: 10,
                height: 10,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                _tableController.getTableAllData();
              },
            )
          ],
        ),
        body: Column(children: [
          Container(
              height: MediaQuery.of(context).size.height - 100,
              child: Obx(() => buildListView(context))),
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
        leading: Icon(Icons.grid_view),
        title: Text(_tableModel.name ?? ''),
        onTap: () {
          /*_tableController.process(saveServer);*/
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TableFieldListPage(
                      tableName: _tableModel.name ?? '',
                    )),
          );
        });
  }
}
