import '../models/table_field_model.dart';

abstract class TableFieldDatasource {
  Future<List<TableFieldModel>> getAll(String tableName);
}
