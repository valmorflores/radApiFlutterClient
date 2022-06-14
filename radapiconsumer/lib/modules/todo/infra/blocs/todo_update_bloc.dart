import 'package:bloc/bloc.dart';
import '/modules/todo/domain/usecases/update_todo_by_id.dart';
import '/modules/todo/infra/models/todo_model.dart';
import '../states/todo_state.dart';
import 'package:rxdart/rxdart.dart';

class TodoUpdateBloc extends Bloc<TodoModel, TodoState> {
  final UpdateTodoById updatetodo;

  TodoUpdateBloc(this.updatetodo) : super(const StartState());

  @override
  Stream<TodoState> mapEventToState(TodoModel todoModel) async* {
    if (todoModel == null) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await updatetodo(todoModel);
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  /*@override
  Stream<Transition<TodoModel, TodoState>> transformEvents(
      Stream<TodoModel> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 5));
    return super.transformEvents(events, transitionFn);
  }
  */

  @override
  void dispose() {
    this.close();
  }
}
