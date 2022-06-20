import '../models/table_data_model.dart';

abstract class TableDataDatasource {
  Future<TableDataModel> getAll(String tableName);
}
