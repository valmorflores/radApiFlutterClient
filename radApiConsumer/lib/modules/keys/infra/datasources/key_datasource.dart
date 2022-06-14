import '/modules/keys/infra/models/key_model.dart';

abstract class KeyDatasource {
  Future<List<KeyModel>> getByKey(String key);
  Future<List<KeyModel>> getById(int id);
}
