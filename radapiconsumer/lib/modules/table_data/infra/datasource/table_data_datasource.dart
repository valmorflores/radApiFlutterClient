import '../models/table_data_model.dart';

abstract class TableDataDatasource {
  Future<List<TableDataModel>> getAll(String tableName);
}
