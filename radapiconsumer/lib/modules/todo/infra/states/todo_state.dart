import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors.dart';

abstract class TodoState {}

class StartState implements TodoState {
  const StartState();
}

class LoadingState implements TodoState {
  const LoadingState();
}

class ErrorState implements TodoState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements TodoState {
  final List<TodoResult> list;
  const SuccessState(this.list);
}
