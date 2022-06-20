import 'package:radapiconsumer/modules/table_data/domain/entities/table_field_record_result.dart';

import '../../domain/entities/table_data_result.dart';
import '../../domain/entities/table_record_result.dart';
import 'table_field_record_model.dart';

class TableRecordModel extends TableRecordResult {
  int? id;
  List<TableFieldRecordResult>? data;

  TableRecordModel({
    this.id,
    this.data,
  }) {
    data = [];
  }

  add(TableFieldRecordResult record) {
    data?.add(record);
  }

  TableRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    return data;
  }
}
