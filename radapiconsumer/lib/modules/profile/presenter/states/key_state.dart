import '../../../../modules/keys/domain/entities/key_result.dart';
import '../../../../modules/keys/domain/errors/errors.dart';
import '../../../../modules/keys/infra/models/key_model.dart';

abstract class KeyState {}

class StartState implements KeyState {
  const StartState();
}

class LoadingState implements KeyState {
  const LoadingState();
}

class ErrorState implements KeyState {
  final Failure error;
  const ErrorState(this.error);
}

class ErrorDeleteState implements KeyState {
  final Failure error;
  const ErrorDeleteState(this.error);
}

class SuccessState implements KeyState {
  final List<KeyResult> list;
  const SuccessState(this.list);
}

class SuccessDeleteState implements KeyState {
  final bool result;
  const SuccessDeleteState(this.result);
}
