import 'package:bloc/bloc.dart';
import '/modules/element/domain/usecases/get_by_index.dart';
import 'package:rxdart/rxdart.dart';
import 'states/element_menu_state.dart';

class MenuBloc extends Bloc<int, ElementMenuState> {
  final GetByIndex searchById;

  MenuBloc(this.searchById) : super(const StartState());

  @override
  Stream<ElementMenuState> mapEventToState(int textSearch) async* {
    if (textSearch <= 0) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await searchById(textSearch);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  /*
  @override
  Stream<Transition<int, ElementMenuState>> transformEvents(
      Stream<int> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(events, transitionFn);
  }
  */

  @override
  void dispose() {
    this.close();
  }
}
