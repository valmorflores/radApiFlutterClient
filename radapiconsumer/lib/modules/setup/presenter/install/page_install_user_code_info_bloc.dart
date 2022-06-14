import 'package:bloc/bloc.dart';
import '/modules/setup/presenter/states/setup_staff_get_state.dart';
import '/modules/staff/domain/usecases/get_me.dart';
import 'package:rxdart/rxdart.dart';

class PageInstallUserCodeInfoBloc extends Bloc<String, SetupStaffGetState> {
  final GetMe searchText;

  PageInstallUserCodeInfoBloc(this.searchText) : super(const StartState());

  @override
  Stream<SetupStaffGetState> mapEventToState(String textSearch) async* {
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
  Stream<Transition<String, SetupStaffGetState>> transformEvents(
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
