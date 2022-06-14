// Separado para poder ter outras gerencias de estado futuras

import '../../../../../modules/clients/domain/entities/client_result.dart';
import '../../../../../modules/clients/domain/errors/errors.dart';

abstract class ClientsState {}

class StartState implements ClientsState {
  const StartState();
}

class LoadingState implements ClientsState {
  const LoadingState();
}

class ErrorState implements ClientsState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements ClientsState {
  final List<ClientResult> list;
  const SuccessState(this.list);
}
