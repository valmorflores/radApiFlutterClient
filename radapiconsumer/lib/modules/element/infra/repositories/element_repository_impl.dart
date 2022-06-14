import 'package:dartz/dartz.dart';
import '/modules/element/domain/errors/erros.dart';
import '/modules/element/domain/entities/element_types.dart';
import '/modules/element/domain/entities/element_result.dart';
import '/modules/element/domain/repositories/elements_repository.dart';
import '/modules/element/infra/datasources/element_datasource.dart';
import '/modules/element/infra/models/element_model.dart';
import 'package:flutter/cupertino.dart';

class ElementRepositoryImpl implements ElementsRepository {
  final ElementDatasource datasource;

  ElementRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ElementResult>>> getAll(String searchText) async {
    List<ElementModel> list;

    try {
      list = await datasource.searchText(searchText);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<ElementResult>>> getByIndex(int id) async {
    // TODO: implement getByIndex
    List<ElementModel> list;

    try {
      list = await datasource.getByIndex(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<ElementResult>>> getByType(
      ElementType type) async {
    List<ElementModel> list;

    try {
      list = await datasource.getByType(type);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
