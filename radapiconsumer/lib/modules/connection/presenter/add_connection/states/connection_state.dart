// Separado para poder ter outras gerencias de estado futuras

import '/modules/connection/domain/entities/connection_result.dart';
import '/modules/connection/domain/errors/errors.dart';

abstract class ConnectionState {}

class StartState implements ConnectionState {
  const StartState();
}

class LoadingState implements ConnectionState {
  const LoadingState();
}

class ErrorState implements ConnectionState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements ConnectionState {
  final List<ConnectionResult> list;
  const SuccessState(this.list);
}
