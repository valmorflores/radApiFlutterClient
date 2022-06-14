import '/modules/workspaces/domain/entities/person_workspace_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';

abstract class PersonWorkspaceState {}

class StartState implements PersonWorkspaceState {
  const StartState();
}

class LoadingState implements PersonWorkspaceState {
  const LoadingState();
}

class ErrorState implements PersonWorkspaceState {
  final Failure error;
  const ErrorState(this.error);
}

class ErrorDeleteState implements PersonWorkspaceState {
  final Failure error;
  const ErrorDeleteState(this.error);
}

class SuccessState implements PersonWorkspaceState {
  final List<PersonWorkspaceResult> personWorkspaces;
  const SuccessState(this.personWorkspaces);
}

class SuccessDeleteState implements PersonWorkspaceState {
  final bool result;
  const SuccessDeleteState(this.result);
}
