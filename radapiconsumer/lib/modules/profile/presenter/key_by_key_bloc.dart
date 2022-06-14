import 'package:bloc/bloc.dart';
import '../../../../modules/keys/domain/usecases/get_by_key.dart';
import '../../../../modules/profile/presenter/states/key_state.dart';

import 'package:rxdart/rxdart.dart';

class KeyByKeyBloc extends Bloc<String, KeyState> {
  final GetByKey getbykey;

  KeyByKeyBloc(this.getbykey) : super(const StartState());

  @override
  void dispose() {
    this.close();
  }

  @override
  Stream<KeyState> mapEventToState(String textSearch) async* {
    if (textSearch == '') {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await getbykey(textSearch);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  // @override
  // Stream<Transition<String, KeyState>> transformEvents(
  //     Stream<String> events, transitionFn) {
  //   events = events.debounceTime(Duration(milliseconds: 5));
  //   return super.transformEvents(events, transitionFn);
  // }
}
