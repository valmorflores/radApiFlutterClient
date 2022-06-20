import '../../domain/entities/table_data_result.dart';
import '../../domain/entities/table_record_result.dart';

class TableDataModel extends TableDataResult {
  List<TableRecordResult>? records;

  TableDataModel({
    this.records,
  }) {
    //records = <TableRecordResult>[];
  }

  add(TableRecordResult record) async {
    records?.add(record);
  }

  assign(List<TableRecordResult> records) async {
    records = records;
  }
}
