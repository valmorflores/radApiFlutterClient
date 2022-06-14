import 'package:bloc/bloc.dart';
import '/modules/profile/domain/usecases/get_id_by_email.dart';
import '/modules/setup/presenter/states/setup_staff_get_id_state.dart';
import 'package:rxdart/rxdart.dart';

class PageInstallUserCodeGetIdBloc extends Bloc<String, SetupStaffGetIdState> {
  final GetIdByEmail searchText;

  PageInstallUserCodeGetIdBloc(this.searchText) : super(const StartState());

  @override
  Stream<SetupStaffGetIdState> mapEventToState(String textSearch) async* {
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

  /*
  @override
  Stream<Transition<String, SetupStaffGetIdState>> transformEvents(
      Stream<String> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 1));
    return super.transformEvents(events, transitionFn);
  }
  */

  @override
  void dispose() {
    this.close();
  }
}
