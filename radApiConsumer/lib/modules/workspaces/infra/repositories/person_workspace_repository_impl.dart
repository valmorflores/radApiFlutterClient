import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/errors/erros.dart';
import '/modules/workspaces/domain/entities/person_workspace_result.dart';
import '/modules/workspaces/domain/repositories/person_workspace_repository.dart';
import '/modules/workspaces/infra/datasources/person_workspace_datasource.dart';
import '/modules/workspaces/infra/models/person_workspace_model.dart';
import 'package:flutter/cupertino.dart';

class PersonWorkspaceRepositoryImpl implements PersonWorkspaceRepository {
  final PersonWorkspaceDatasource datasource;

  PersonWorkspaceRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<PersonWorkspaceResult>>> getByPersonId(
      int id) async {
    List<PersonWorkspaceModel> list;
    try {
      list = await datasource.getByPersonId(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }
}
