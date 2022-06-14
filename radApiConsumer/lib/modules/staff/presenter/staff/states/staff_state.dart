// Separado para poder ter outras gerencias de estado futuras

import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/errors/errors.dart';

abstract class StaffState {}

class StartState implements StaffState {
  const StartState();
}

class LoadingState implements StaffState {
  const LoadingState();
}

class ErrorState implements StaffState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements StaffState {
  final List<StaffResult> list;
  const SuccessState(this.list);
}
