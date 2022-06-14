import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/entities/person_workspace_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';

abstract class PersonWorkspaceRepository {
  Future<Either<Failure, List<PersonWorkspaceResult>>> getByPersonId(int id);
}
