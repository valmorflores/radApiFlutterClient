import 'package:bloc/bloc.dart';
import '/modules/todo/domain/usecases/get_todo_all.dart';
import '../../infra/states/todo_state.dart';
import 'package:rxdart/rxdart.dart';

class TodoHomeBloc extends Bloc<int, TodoState> {
  final GetTodoAll searchById;

  TodoHomeBloc(this.searchById) : super(const StartState());

  @override
  Stream<TodoState> mapEventToState(int textSearch) async* {
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

  /*
  @override
  Stream<Transition<int, TodoState>> transformEvents(
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
