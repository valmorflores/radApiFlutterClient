import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radapiconsumer/modules/table_field/infra/models/table_field_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

import '../infra/models/table_data_model.dart';
import '../infra/models/table_record_model.dart';
import 'controllers/table_data_controller.dart';

/// The application that contains datagrid on it.
class TableDataGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataGridSample();
  }
}

/// The home page of the application which hosts the datagrid.
class DataGridSample extends StatefulWidget {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  DataGridSample({Key? key}) : super(key: key);

  @override
  _DataGridSampleState createState() => _DataGridSampleState();
}

class _DataGridSampleState extends State<DataGridSample> {
  /// Controller
  TableDataController tableController = Get.put(TableDataController());

  /// DataGridSource required for SfDataGrid to obtain the row data.
  _SampleDataGridSource freezePanesDataGridSource = _SampleDataGridSource();

  List<GridColumn> getColumns() {
    TableDataModel data = tableController.tableList[0];
    List<GridColumn> columns;
    columns = <GridColumn>[];
    data.fields?.forEach((element) {
      columns.add(GridColumn(
          columnName: element.name ?? '',
          label: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(8.0),
            child: Text(
              element.name ?? '',
              overflow: TextOverflow.ellipsis,
            ),
          )));
    });

    return columns;
  }

  SfDataGrid _buildDataGrid() {
    return SfDataGrid(
      source: freezePanesDataGridSource,
      columns: getColumns(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabela ${tableController.tableName}'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Text('Conteúdo da tabela'),
              TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Rebuild'),
                    ),
                  )),
            ],
          ),
          Expanded(child: _buildDataGrid()),
        ],
      ),
    );
  }
}

class _SampleDataGridSource extends DataGridSource {
  final TableDataController _tableController = Get.put(TableDataController());

  _SampleDataGridSource() {
    products = getProducts();
    buildDataGridRows();
  }

  getProducts() {
    if (_tableController.tableList.isNotEmpty) {
      return _tableController.tableList[0].records;
    } else {
      return [];
    }
  }

  getFields() {
    return _tableController.tableList[0].fields;
  }

  final math.Random random = math.Random();

  List<DataGridRow> dataGridRows = [];

  List<TableRecordModel> products = [];

  // Building DataGridRows

  void buildDataGridRows() {
    List<TableFieldModel> fields = getFields();
    List<DataGridCell> cells = [];
    dataGridRows = products.map<DataGridRow>((dataGridRow) {
      fields.forEach((element) {
        cells.add(DataGridCell(columnName: 'id', value: dataGridRow.data));
      });
      return DataGridRow(cells: cells);
    }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[5].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[6].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[7].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          DateFormat('MM/dd/yyyy').format(row.getCells()[8].value).toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[9].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[10].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          NumberFormat.currency(locale: 'en_US', symbol: '\$')
              .format(row.getCells()[11].value)
              .toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}
