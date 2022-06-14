import 'package:bloc/bloc.dart';
import '/modules/todo/domain/usecases/update_todo_multi.dart';
import '/modules/todo/infra/controllers/todo_items_controller.dart';
import '/modules/todo/infra/states/todo_state_multiupdate.dart';
import 'package:rxdart/rxdart.dart';

class TodoUpdateMultiBloc
    extends Bloc<TodoItemsController, TodoStateMultiUpdate> {
  final UpdateTodoMulti updatetodo;

  TodoUpdateMultiBloc(this.updatetodo) : super(const StartState());

  @override
  Stream<TodoStateMultiUpdate> mapEventToState(
      TodoItemsController todoModel) async* {
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

  /*
  @override
  Stream<Transition<TodoItemsController, TodoStateMultiUpdate>> transformEvents(
      Stream<TodoItemsController> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 5));
    return super.transformEvents(events, transitionFn);
  }
  */

  @override
  void dispose() {
    this.close();
  }
}
