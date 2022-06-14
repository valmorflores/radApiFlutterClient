import 'package:bloc/bloc.dart';
import '/modules/staff/domain/usecases/get_staff_all.dart';
import '/modules/staff/presenter/staff/states/staff_state.dart';
import 'package:rxdart/rxdart.dart';

class StaffHomeBloc extends Bloc<int, StaffState> {
  final GetStaffAll searchById;

  StaffHomeBloc(this.searchById) : super(const StartState());

  @override
  Stream<StaffState> mapEventToState(int textSearch) async* {
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

  /*@override
  Stream<Transition<int, StaffState>> transformEvents(
      Stream<int> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(events, transitionFn);
  }*/

  @override
  void dispose() {
    this.close();
  }
}
