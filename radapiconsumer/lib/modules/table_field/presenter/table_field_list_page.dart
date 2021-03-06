import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:radapiconsumer/modules/table/infra/models/table_model.dart';

import '../../table_data/presenter/table_data_list_page.dart';
import '../infra/models/table_field_model.dart';
import 'controllers/table_field_controller.dart';

class TableFieldListPage extends StatelessWidget {
  TableFieldController _tableController = Get.put(TableFieldController());

  String tableName;

  TableFieldListPage({required this.tableName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Estrutura da tabela [' + this.tableName + ']'),
          actions: <Widget>[
            FutureBuilder(
              future: _tableController.refreshAll(this.tableName),
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
                //_tableController.getTableAll(this.tableName);
                _tableController.refreshAll(this.tableName);
              },
            )
          ],
        ),
        body: Column(children: [
          Row(
            children: [
              TextButton(
                child: Text('Dados'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TableDataListPage(tableName: tableName)),
                  );
                },
              )
            ],
          ),
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

  ListTile buildListTile(
      BuildContext context, TableFieldModel _tableFieldModel) {
    return ListTile(
        leading: Icon(Icons.edit_note),
        title: Text(_tableFieldModel.name ?? ''),
        subtitle: Text((_tableFieldModel.type ?? '') +
            ' ' +
            (_tableFieldModel.size ?? '').toString() +
            ' ' +
            (_tableFieldModel.default_data != null ? ' Default ' : '') +
            (_tableFieldModel.default_data ?? '').toString()),
        onTap: () {
          /*_tableController.process(saveServer);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserLoginPage(0)),
          );*/
        });
  }
}
