import '/modules/update/infra/models/url_model.dart';

abstract class UrlDatasource {
  Future<UrlModel> getAll();
}
