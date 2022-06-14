import '/modules/update/infra/models/update_model.dart';

abstract class UpdateDatabaseDatasource {
  Future<List<UpdateModel>> getUpdate();
}
