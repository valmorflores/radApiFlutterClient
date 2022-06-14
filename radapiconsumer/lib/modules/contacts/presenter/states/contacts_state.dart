// Separado para poder ter outras gerencias de estado futuras
import '/modules/contacts/domain/entities/contact_result.dart';
import '/modules/contacts/domain/errors/erros.dart';

abstract class ContactsState {}

class StartState implements ContactsState {
  const StartState();
}

class LoadingState implements ContactsState {
  const LoadingState();
}

class ErrorState implements ContactsState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements ContactsState {
  final List<ContactResult> list;
  const SuccessState(this.list);
}
