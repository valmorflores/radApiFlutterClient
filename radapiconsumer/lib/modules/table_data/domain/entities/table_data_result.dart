import '../../../table_field/domain/entities/table_field_result.dart';
import 'table_field_record_result.dart';
import 'table_record_result.dart';

/* Coleção de registros (records) */
class TableDataResult {
  List<TableRecordResult>? records;
  List<TableFieldResult>? fields;
  TableDataResult({this.fields, this.records});
}
