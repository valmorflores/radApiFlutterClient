import '../models/ConnectionModel.dart';

abstract class ConnectionDatasource {
  Future<List<ConnectionModel>> searchText(String textSearch);
  Future<List<ConnectionModel>> getAll();
  Future<List<ConnectionModel>> getById(int id);
  Future<List<ConnectionModel>> connectionAdd(ConnectionModel connectionModel);
  Future<List<ConnectionModel>> updateById(ConnectionModel ConnectionModel);
  Future<bool> deleteConnectionById(int id);
}
