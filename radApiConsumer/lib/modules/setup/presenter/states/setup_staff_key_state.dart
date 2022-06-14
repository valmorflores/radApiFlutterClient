// Separado para poder ter outras gerencias de estado futuras
import '/modules/staff/domain/errors/staff_key_errors.dart';
import '/modules/staff/domain/entities/staff_key_result.dart';

abstract class SetupStaffKeyState {}

class StartState implements SetupStaffKeyState {
  const StartState();
}

class LoadingState implements SetupStaffKeyState {
  const LoadingState();
}

class ErrorState implements SetupStaffKeyState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements SetupStaffKeyState {
  final List<StaffKeyResult> list;
  const SuccessState(this.list);
}
