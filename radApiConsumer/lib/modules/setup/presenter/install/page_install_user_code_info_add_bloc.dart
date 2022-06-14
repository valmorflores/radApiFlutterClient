import 'package:bloc/bloc.dart';
import '/modules/setup/presenter/states/setup_staff_get_state.dart';
import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/domain/usecases/add_staff.dart';
import '/modules/staff/infra/models/staff_model.dart';
import 'package:rxdart/rxdart.dart';

class PageInstallUserCodeInfoAddBloc
    extends Bloc<StaffModel, SetupStaffGetState> {
  final AddStaff searchText;

  PageInstallUserCodeInfoAddBloc(this.searchText) : super(const StartState());

  @override
  Stream<SetupStaffGetState> mapEventToState(StaffModel textSearch) async* {
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
  Stream<Transition<StaffModel, SetupStaffGetState>> transformEvents(
      Stream<StaffModel> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 1));
    return super.transformEvents(events, transitionFn);
  }
  */

  @override
  void dispose() {
    this.close();
  }
}
