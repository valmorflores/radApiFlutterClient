import 'package:bloc/bloc.dart';
import '/modules/contacts/domain/usecases/get_by_id.dart';
import 'package:rxdart/rxdart.dart';

import 'states/contacts_state.dart';

class ContactDetailBloc extends Bloc<int, ContactsState> {
  final GetById searchById;

  ContactDetailBloc(this.searchById) : super(const StartState());

  @override
  Stream<ContactsState> mapEventToState(int textSearch) async* {
    if (textSearch <= 0) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await searchById(textSearch);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  @override
  void dispose() {
    this.close();
  }
}
