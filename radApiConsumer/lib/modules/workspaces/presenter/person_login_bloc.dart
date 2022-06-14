import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import '/modules/workspaces/domain/usecases/put_login.dart';
import '/modules/workspaces/infra/models/person_login_model.dart';
import '/modules/workspaces/presenter/states/person_state.dart';

class PersonLoginBloc extends Bloc<PersonLoginModel, PersonState> {
  final PostLogin postLogin;

  PersonLoginBloc(this.postLogin) : super(const StartState());

  @override
  void dispose() {
    this.close();
  }

  @override
  Stream<PersonState> mapEventToState(PersonLoginModel login) async* {
    if (login == null) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await postLogin(login.email!, login.password!);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessPersonLoginState(success),
    );
  }

  /*
  @override
  Stream<Transition<PersonLoginModel, PersonState>> transformEvents(
      Stream<PersonLoginModel> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(events, transitionFn);
  }
  */
}
