import '/modules/element/domain/entities/element_types.dart';
import '/modules/element/infra/models/element_model.dart';

abstract class ElementDatasource {
  Future<List<ElementModel>> searchText(String textSearch);
  Future<List<ElementModel>> getAll();
  Future<List<ElementModel>> getByIndex(int id);
  Future<List<ElementModel>> getByType(ElementType type);
}
