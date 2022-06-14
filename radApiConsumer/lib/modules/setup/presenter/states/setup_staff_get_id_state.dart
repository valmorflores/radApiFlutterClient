// Separado para poder ter outras gerencias de estado futuras
import '/modules/profile/domain/errors/erros.dart';

abstract class SetupStaffGetIdState {}

class StartState implements SetupStaffGetIdState {
  const StartState();
}

class LoadingState implements SetupStaffGetIdState {
  const LoadingState();
}

class ErrorState implements SetupStaffGetIdState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements SetupStaffGetIdState {
  final int id;
  const SuccessState(this.id);
}
