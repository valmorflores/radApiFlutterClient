import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../infra/models/table_data_model.dart';
import '../infra/models/table_record_model.dart';
import 'controllers/table_data_controller.dart';

class TableDataListPage extends StatelessWidget {
  TableDataController _tableController = Get.put(TableDataController());

  String tableName;

  TableDataListPage({required this.tableName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dados da tabela [' + this.tableName + ']'),
          actions: <Widget>[
            FutureBuilder(
              future: _tableController.refreshAll(this.tableName),
              builder: (context, snapshot) => Container(
                width: 10,
                height: 10,
              ),
            ),
            IconButton(
              icon: const Icon(
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
                  //this.tableName
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TableDataPage(this.tableName)),
                  );
                  */
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
        itemCount: _tableController.tableList[0].records?.length,
        itemBuilder: (context, index) {
          final tableData = _tableController.tableList[0].records
              ?.elementAt(index) as TableRecordModel;
          return buildListTile(context, tableData);
        });
  }

  ListTile buildListTile(
      BuildContext context, TableRecordModel _tableFieldModel) {
    return ListTile(
        leading: Icon(Icons.edit_note),
        title: Text(_tableFieldModel.data?[0].fieldData ?? ''),
        subtitle: Text(_tableFieldModel.data?[1].fieldData ?? ''),
        onTap: () {
          /*_tableController.process(saveServer);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserLoginPage(0)),
          );*/
        });
  }

  Row buildRowData(BuildContext context, TableRecordModel _tableFieldModel) {
    return Row(
      children: [],
    );
  }
}

/**
 * 
 * 
 * 
 * (_tableFieldModel.type ?? '') +
            ' ' +
            (_tableFieldModel.size ?? '').toString() +
            ' ' +
            (_tableFieldModel.default_data != null ? ' Default ' : '') +
            (_tableFieldModel.default_data ?? '').toString()
 */