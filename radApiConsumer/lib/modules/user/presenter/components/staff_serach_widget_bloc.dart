import 'package:bloc/bloc.dart';
import '/modules/staff/domain/usecases/get_staff_all.dart';
import '/modules/staff/presenter/staff/states/staff_state.dart';
import 'package:rxdart/rxdart.dart';

class StaffSearchWidgetBloc extends Bloc<String, StaffState> {
  final GetStaffAll searchText;

  StaffSearchWidgetBloc(this.searchText) : super(const StartState());

  @override
  Stream<StaffState> mapEventToState(String textSearch) async* {
    if (textSearch == '') {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await searchText();
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  /*@override
  Stream<Transition<String, StaffState>> transformEvents(
      Stream<String> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 1));
    return super.transformEvents(events, transitionFn);
  }*/

  @override
  void dispose() {
    this.close();
  }
}
