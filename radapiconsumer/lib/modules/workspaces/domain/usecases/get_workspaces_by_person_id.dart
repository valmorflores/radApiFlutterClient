import 'package:dartz/dartz.dart';
import '/modules/workspaces/domain/entities/person_workspace_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';
import '/modules/workspaces/domain/repositories/person_workspace_repository.dart';

mixin GetWorkspacesByPersonId {
  Future<Either<Failure, List<PersonWorkspaceResult>>> call(int id);
}

//? @Injectable(singleton: false)
class GetWorkspacesByPersonIdImpl implements GetWorkspacesByPersonId {
  final PersonWorkspaceRepository repository;

  GetWorkspacesByPersonIdImpl(this.repository);

  @override
  Future<Either<Failure, List<PersonWorkspaceResult>>> call(int id) async {
    var option = optionOf(id);

    return option.fold(() => Left(InvalidSearchText()), (id) async {
      var result = await repository.getByPersonId(id);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
