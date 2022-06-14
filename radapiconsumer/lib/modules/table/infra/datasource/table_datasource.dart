
import '../models/table_model.dart';

abstract class TableDatasource {
  Future<List<TableModel>> getAll();
}
