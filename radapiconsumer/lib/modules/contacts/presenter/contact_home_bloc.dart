import 'package:bloc/bloc.dart';
import '/modules/contacts/domain/usecases/get_all.dart';
import '/modules/contacts/presenter/states/contacts_state.dart';
import 'package:rxdart/rxdart.dart';

class ContactHomeBloc extends Bloc<int, ContactsState> {
  final GetAll searchById;

  ContactHomeBloc(this.searchById) : super(const StartState());

  @override
  Stream<ContactsState> mapEventToState(int textSearch) async* {
    if (textSearch <= 0) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await searchById();
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
