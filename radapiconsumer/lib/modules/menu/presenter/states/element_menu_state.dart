// Separado para poder ter outras gerencias de estado futuras

import '/modules/element/domain/entities/element_result.dart';
import '/modules/element/domain/errors/erros.dart';

abstract class ElementMenuState {}

class StartState implements ElementMenuState {
  const StartState();
}

class LoadingState implements ElementMenuState {
  const LoadingState();
}

class ErrorState implements ElementMenuState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements ElementMenuState {
  final List<ElementResult> list;
  const SuccessState(this.list);
}
