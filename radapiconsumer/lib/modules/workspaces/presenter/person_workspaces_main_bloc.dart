import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import '/modules/workspaces/presenter/states/person_workspace_state.dart';

class PersonWorkspacesMainBloc extends Bloc<int, PersonWorkspaceState> {
  final getByid;

  PersonWorkspacesMainBloc(this.getByid) : super(const StartState());

  @override
  void dispose() {
    this.close();
  }

  @override
  Stream<PersonWorkspaceState> mapEventToState(int id) async* {
    if (id == 0) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await getByid(id);
    /* 
    08/2021 -> ANALISE URGENTE, NULLSAFTY, 
   COMENTADO SO PRA DESTRAVAR DESENVOLVIMENTO NESTA DATA
   
     yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    ); 
    
    */
  }

  /*
  @override
  Stream<Transition<int, PersonWorkspaceState>> transformEvents(
      Stream<int> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(events, transitionFn);
  }
  */
}
