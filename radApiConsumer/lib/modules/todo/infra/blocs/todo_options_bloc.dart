import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:bloc/bloc.dart';
import '/modules/todo/domain/errors/errors_todo_options.dart';
import '/modules/todo/infra/models/todo_options_model.dart';
import '../../infra/states/todo_options_state.dart';
import 'package:flutter/material.dart';

class TodoOptionsBloc extends Bloc<TodoOptionsModel, TodoOptionsState> {
  TodoOptionsModel _optionsModel = TodoOptionsModel();

  TodoOptionsBloc(TodoOptionsState initialState) : super(initialState);

  //TodoOptionsBloc(initialState) : super(initialState);

  TodoOptionsModel get optionsModel => _optionsModel;

  // 1
  final _blocController = StreamController<TodoOptionsModel>();

  // 2
  Stream<TodoOptionsModel> get minhaStream => _blocController.stream;

  // 3
  adicionar(TodoOptionsModel optionsModel) async {
    var result = optionsModel;
    return result; //call(result);

    //_blocController.sink.add(optionsModel);
  }

  fecharStream() {
    _blocController.close();
  }

  @override
  Stream<TodoOptionsState> mapEventToState(TodoOptionsModel event) async* {
    if (event == null) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await adicionar(event);
    debugPrint(result.toString());
    yield SuccessState(result);
    /*yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );*/
  }
}
