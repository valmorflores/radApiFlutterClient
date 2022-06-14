import 'package:bloc/bloc.dart';
import '/modules/contacts/domain/usecases/get_users.dart';
import '/modules/contacts/presenter/states/contacts_state.dart';
import 'package:rxdart/rxdart.dart';

class ContactSearchWidgetBloc extends Bloc<String, ContactsState> {
  final GetUsers searchText;

  ContactSearchWidgetBloc(this.searchText) : super(const StartState());

  @override
  Stream<ContactsState> mapEventToState(String textSearch) async* {
    if (textSearch == '') {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await searchText(textSearch);
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
