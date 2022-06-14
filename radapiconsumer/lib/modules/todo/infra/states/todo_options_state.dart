import '/modules/todo/domain/errors/errors.dart';
import '/modules/todo/infra/models/todo_options_model.dart';

abstract class TodoOptionsState {}

class StartState implements TodoOptionsState {
  const StartState();
}

class LoadingState implements TodoOptionsState {
  const LoadingState();
}

class ErrorState implements TodoOptionsState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements TodoOptionsState {
  final TodoOptionsModel options;
  const SuccessState(this.options);
}
