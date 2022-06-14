import 'package:bloc/bloc.dart';
import '../../../../modules/profile/domain/usecases/get_details_by_id.dart';
import '../../../../modules/profile/domain/usecases/get_id_by_email.dart';
import '../../../../modules/profile/presenter/states/profile_id_state.dart';
import 'package:rxdart/rxdart.dart';

class ProfileIdByEmailBloc extends Bloc<String, ProfileIdState> {
  final GetIdByEmail getidbyemail;

  ProfileIdByEmailBloc(this.getidbyemail) : super(const StartState());

  @override
  void dispose() {
    this.close();
  }

  @override
  Stream<ProfileIdState> mapEventToState(String textSearch) async* {
    if (textSearch == '') {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await getidbyemail(textSearch);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

/*   @override
  Stream<Transition<String, ProfileIdState>> transformEvents(
      Stream<String> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 200));
    return super.transformEvents(events, transitionFn);
  }
 */

}
