import '/modules/workspaces/domain/entities/person_result.dart';
import '/modules/workspaces/domain/errors/erros.dart';

abstract class PersonState {}

class StartState implements PersonState {
  const StartState();
}

class LoadingState implements PersonState {
  const LoadingState();
}

class ErrorState implements PersonState {
  final Failure error;
  const ErrorState(this.error);
}

class ErrorLoginFailState implements PersonState {
  final Failure error;
  const ErrorLoginFailState(this.error);
}

class ErrorLoginNotFoundState implements PersonState {
  final Failure error;
  const ErrorLoginNotFoundState(this.error);
}

class ErrorDeleteState implements PersonState {
  final Failure error;
  const ErrorDeleteState(this.error);
}

class SuccessState implements PersonState {
  final List<PersonResult> list;
  const SuccessState(this.list);
}

class SuccessPersonLoginState implements PersonState {
  final PersonResult person;
  const SuccessPersonLoginState(this.person);
}

class SuccessDeleteState implements PersonState {
  final bool result;
  const SuccessDeleteState(this.result);
}
