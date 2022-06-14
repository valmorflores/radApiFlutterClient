import 'package:bloc/bloc.dart';
import '/modules/todo/domain/usecases/add_todo.dart';
import '../states/todo_state.dart';
import 'package:rxdart/rxdart.dart';

class TodoAddBloc extends Bloc<String, TodoState> {
  final AddTodo addtodo;

  TodoAddBloc(this.addtodo) : super(const StartState());

  @override
  Stream<TodoState> mapEventToState(String textSearch) async* {
    if (textSearch == '') {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await addtodo(textSearch);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  /*
  @override
  Stream<Transition<String, TodoState>> transformEvents(
      Stream<String> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 5));
    return super.transformEvents(events, transitionFn);
  }
  */

  @override
  void dispose() {
    this.close();
  }
}
