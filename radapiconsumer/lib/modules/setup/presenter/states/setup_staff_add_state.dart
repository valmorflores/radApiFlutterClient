// Separado para poder ter outras gerencias de estado futuras

import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';

abstract class SetupStaffAddState {}

class StartState implements SetupStaffAddState {
  const StartState();
}

class LoadingState implements SetupStaffAddState {
  const LoadingState();
}

class ErrorState implements SetupStaffAddState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements SetupStaffAddState {
  final List<StaffResult> list;
  const SuccessState(this.list);
}
