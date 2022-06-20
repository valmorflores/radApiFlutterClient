/* Campo individual, com seu respectivo valor */
import 'package:radapiconsumer/modules/table_data/domain/entities/table_field_record_result.dart';

class TableFieldRecordModel extends TableFieldRecordResult {
  int? id;
  int? fieldRecord;
  String? fieldName;
  String? fieldData;

  TableFieldRecordModel({
    this.id,
    this.fieldRecord,
    this.fieldName,
    this.fieldData,    
  });
 
}

