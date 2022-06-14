import 'package:bloc/bloc.dart';
import '/modules/profile/domain/usecases/get_details_by_id.dart';
import 'package:rxdart/rxdart.dart';
import '/modules/profile/infra/models/profile_model.dart';
import '/modules/profile/presenter/states/profile_state.dart';

class ProfileMainBloc extends Bloc<int, ProfileState> {
  final GetDetailsById getdetailbyid;

  ProfileMainBloc(this.getdetailbyid) : super(const StartState());

  @override
  void dispose() {
    this.close();
  }

  @override
  Stream<ProfileState> mapEventToState(int textSearch) async* {
    if (textSearch <= 0) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await getdetailbyid(textSearch);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  // @override
  // Stream<Transition<int, ProfileState>> transformEvents(
  //     Stream<int> events, transitionFn) {
  //   events = events.debounceTime(Duration(milliseconds: 500));
  //   return super.transformEvents(events, transitionFn);
  // }

}
