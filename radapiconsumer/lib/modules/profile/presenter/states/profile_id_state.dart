import '../../../../modules/profile/domain/errors/erros.dart';

abstract class ProfileIdState {}

class StartState implements ProfileIdState {
  const StartState();
}

class LoadingState implements ProfileIdState {
  const LoadingState();
}

class ErrorState implements ProfileIdState {
  final Failure error;
  const ErrorState(this.error);
}

class ErrorDeleteState implements ProfileIdState {
  final Failure error;
  const ErrorDeleteState(this.error);
}

class SuccessState implements ProfileIdState {
  final int id;
  const SuccessState(this.id);
}

class SuccessDeleteState implements ProfileIdState {
  final bool result;
  const SuccessDeleteState(this.result);
}
