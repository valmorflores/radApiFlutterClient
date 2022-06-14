import 'dart:async';

import '/modules/todo/domain/repositories/todo_repository.dart';
import '/modules/todo/domain/usecases/add_todo.dart';
import '/modules/todo/external/api/eiapi_todo_datasource.dart';
import '/modules/todo/infra/datasources/todo_datasource.dart';
import '/modules/todo/infra/models/todo_model.dart';
import '/modules/todo/infra/repositories/todo_repository_impl.dart';
import '/modules/todo/infra/states/todo_state.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/material.dart';
import '../../infra/blocs/todo_add_bloc.dart';

class TodoAdd extends StatefulWidget {
  final Function? onSuccess;

  const TodoAdd({Key? key, this.onSuccess}) : super(key: key);
  @override
  _TodoAddState createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  late bool _showProgress;
  final _textName = TextEditingController();
  final dio = WksCustomDio.withAuthentication().instance;
  late TodoDatasource datasource;
  late TodoRepository repository;
  late AddTodo search;
  late TodoAddBloc bloc;
  late StreamSubscription listenResponse;
  late List<TodoModel> _listTodos;

  @override
  void initState() {
    super.initState();
    _showProgress = false;
    datasource = EIAPITodoDatasource(dio);
    repository = TodoRepositoryImpl(datasource);
    search = AddTodoImpl(repository);
    bloc = TodoAddBloc(search);
    _listTodos = [];
  }

  @override
  void dispose() {
    super.dispose();
    listenResponse.cancel();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                bloc.add(_textName.value.text);
                _textName.clear();
                _showProgress = true;
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    _showProgress ? progressBar(context) : Container(),
                    _listaStream(),
                    Expanded(
                      flex: 3,
                      child: Container(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 200,
                          color: Colors.black12,
                          child: Form(
                              child: Column(
                            children: [
                              TextFormField(
                                  autofocus: true,
                                  maxLines: 50,
                                  controller: _textName,
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      hintText: 'Fazer uma atividade'),
                                  onEditingComplete: () {
                                    debugPrint('complete');
                                  },
                                  onFieldSubmitted: (term) {
                                    // process
                                    bloc.add(_textName.value.text);
                                    _textName.clear();
                                    _showProgress = true;
                                  })
                            ],
                          ))),
                    ),
                  ],
                ),
              ),
            )));
  }

  _futureClose(List<TodoModel> list) async {
    /*setState(() {
      _showProgress = true;
    });*/
    await Future.delayed(Duration(seconds: 1));
    debugPrint('Delay complete for Future');
    // Reload bl
    Navigator.of(context).pop(list);
    // return Container();
  }

  Widget _listaStream() {
    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Opa! Uma info na stream TODOADD...');
            final state = bloc.state;
            if (state is StartState) {
              return Center(child: Text(''));
            } else if (state is ErrorState) {
              return Center(
                  child: Text('Erro ao executar:' + state.error.toString()));
            } else if (state is LoadingState) {
              return Center(
                child: progressBar(context),
              );
            } else {
              final list = (state as SuccessState).list;
              debugPrint('Size = ' + list.length.toString());
              _showProgress = true;
              // Put items into list
              list.forEach((element) {
                _listTodos.add(element as TodoModel);
              });
              return Container();
              /*return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  child: _showProgress
                      ? Expanded(
                          child: SizedBox(
                            child: ListView.builder(
                                padding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                                itemCount: list.length,
                                itemBuilder: (_, id) {
                                  final item = list[id];
                                  return ListTile(
                                    onTap: () {},
                                    title: Text(
                                      item.description,
                                    ),
                                    subtitle: Text(item.todoid.toString()),
                                  );
                                }),
                          ),
                        )
                      : Container(
                          width: 200,
                          color: Colors.red,
                          child: SizedBox(
                            width: 200,
                          ),
                        ));
                        */
            }
          } else {
            return Container();
          }
        });
  }

  fclose() {
    return Row(children: [
      Expanded(child: Container()),
      GestureDetector(
          child: Container(width: 32, height: 32, child: Icon(Icons.close)),
          onTap: () {
            _futureClose(_listTodos);
            //Navigator.pop(context);
          })
    ]);
  }
}
