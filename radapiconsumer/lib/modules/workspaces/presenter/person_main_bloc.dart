import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import '/modules/workspaces/domain/usecases/get_by_id.dart';
import '/modules/workspaces/presenter/states/person_state.dart';

class PersonMainBloc extends Bloc<int, PersonState> {
  final GetById getdetailbyid;

  PersonMainBloc(this.getdetailbyid) : super(const StartState());

  @override
  void dispose() {
    this.close();
  }

  @override
  Stream<PersonState> mapEventToState(int id) async* {
    if (id == 0) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await getdetailbyid(id);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  /*
  @override
  Stream<Transition<int, PersonState>> transformEvents(
      Stream<int> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(events, transitionFn);
  }
  */
}
