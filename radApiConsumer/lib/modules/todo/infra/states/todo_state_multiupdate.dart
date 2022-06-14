import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/domain/errors/errors_todo_statusrecord.dart';
import '/modules/todo/infra/models/todo_model.dart';

abstract class TodoStateMultiUpdate {}

class StartState implements TodoStateMultiUpdate {
  const StartState();
}

class LoadingState implements TodoStateMultiUpdate {
  const LoadingState();
}

class ErrorState implements TodoStateMultiUpdate {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements TodoStateMultiUpdate {
  final List<TodoResult> list;
  const SuccessState(this.list);
}
