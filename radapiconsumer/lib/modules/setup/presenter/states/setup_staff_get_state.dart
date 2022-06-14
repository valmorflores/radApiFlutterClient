// Separado para poder ter outras gerencias de estado futuras

import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';

abstract class SetupStaffGetState {}

class StartState implements SetupStaffGetState {
  const StartState();
}

class LoadingState implements SetupStaffGetState {
  const LoadingState();
}

class ErrorState implements SetupStaffGetState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements SetupStaffGetState {
  final List<StaffResult> list;
  const SuccessState(this.list);
}
