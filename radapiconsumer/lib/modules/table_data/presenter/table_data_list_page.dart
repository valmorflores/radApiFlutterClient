import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:radapiconsumer/modules/table_data/presenter/table_data_grid_page.dart';

import '../infra/models/table_data_model.dart';
import '../infra/models/table_record_model.dart';
import 'controllers/table_data_controller.dart';
import 'table_data_grid_source.dart';

class TableDataListPage extends StatelessWidget {
  TableDataController _tableController = Get.put(TableDataController());

  String tableName;

  TableDataListPage({required this.tableName, super.key});

  @override
  Widget build(BuildContext context) {
    _tableController.setTableName(tableName);
    return Scaffold(
        appBar: AppBar(
          title: Text('Dados da tabela [' + tableName + ']'),
          actions: <Widget>[
            FutureBuilder(
              future: _tableController.refreshAll(tableName),
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
                child: Text('Grid'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TableDataGridPage()),
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
        itemCount: _tableController.tableList.length > 0
            ? _tableController.tableList[0].records?.length
            : 0,
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