import 'package:bloc/bloc.dart';
import '/modules/setup/presenter/states/setup_staff_key_state.dart';
import '/modules/staff/domain/usecases/add_staff_key.dart';
import '/modules/staff/infra/models/staff_key_model.dart';
import 'package:rxdart/rxdart.dart';

class PageInstallUserCodeInfoAddKeyBloc
    extends Bloc<StaffKeyModel, SetupStaffKeyState> {
  final AddStaffKey searchText;

  PageInstallUserCodeInfoAddKeyBloc(this.searchText)
      : super(const StartState());

  @override
  Stream<SetupStaffKeyState> mapEventToState(StaffKeyModel textSearch) async* {
    if (textSearch == null) {
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
  Stream<Transition<StaffKeyModel, SetupStaffKeyState>> transformEvents(
      Stream<StaffKeyModel> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 1));
    return super.transformEvents(events, transitionFn);
  }
  */

  @override
  void dispose() {
    this.close();
  }
}
