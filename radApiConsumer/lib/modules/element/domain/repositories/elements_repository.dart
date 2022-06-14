import 'package:dartz/dartz.dart';
import '/modules/element/domain/entities/element_result.dart';
import '/modules/element/domain/entities/element_types.dart';
import '/modules/element/domain/errors/erros.dart';

abstract class ElementsRepository {
  Future<Either<Failure, List<ElementResult>>> getAll(String searchText);
  Future<Either<Failure, List<ElementResult>>> getByIndex(int id);
  Future<Either<Failure, List<ElementResult>>> getByType(ElementType type);
}
