import '/core/ui/layout/my_layout.dart';
import '/core/widgets/_widget_need_refresh_error.dart';
import '/core/widgets/_widget_page_filter_input.dart';
import '/modules/todo/domain/repositories/todo_repository.dart';
import '/modules/todo/domain/usecases/get_todo_all.dart';
import '/modules/todo/domain/usecases/update_todo_by_id.dart';
import '/modules/todo/domain/usecases/update_todo_multi.dart';
import '/modules/todo/domain/utils/enum_todo_filters.dart';
import '/modules/todo/domain/utils/enum_todo_groups.dart';
import '/modules/todo/domain/utils/enum_todo_orders.dart';
import '/modules/todo/external/api/eiapi_todo_datasource.dart';
import '/modules/todo/infra/blocs/todo_update_bloc.dart';
import '/modules/todo/infra/blocs/todo_update_multi_bloc.dart';
import '/modules/todo/infra/constants/enum_staterecords.dart';
import '/modules/todo/infra/controllers/todo_items_controller.dart';
import '/modules/todo/infra/datasources/todo_datasource.dart';
import '/modules/todo/infra/models/todo_item_status.dart';
import '/modules/todo/infra/models/todo_model.dart';
import '/modules/todo/infra/models/todo_options_model.dart';
import '/modules/todo/infra/repositories/todo_repository_impl.dart';
import '/modules/todo/infra/states/todo_state.dart';
import '/modules/todo/infra/states/todo_options_state.dart' as todoOptionsState;
import '/modules/todo/presenter/todo_crud/todo_undo_confirmation.dart';
import '/modules/todo/presenter/todo_datamodule/todo_sync.dart';
import '/utils/dialog/hero_dialog_route.dart';
import '/utils/globals.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/utils/wks_custom_dio.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';
import '../../infra/constants/constants.dart';
import 'todo_delete_confirmation.dart';
import 'todo_edit_popupcard.dart';
import '../../infra/blocs/todo_options_bloc.dart';
import 'todo_options_button.dart';
import 'todo_add.dart';
import '../../infra/blocs/todo_home_bloc.dart';

import '/modules/todo/infra/states/todo_state_multiupdate.dart'
    as multiupdate_state;

class TodoHome extends StatefulWidget {
  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final TextEditingController _searchTextController = TextEditingController();
  late String _filter;

  late List<int> selectedTodo;
  late List<int> _nextRefreshElimiteStatus;
  final dio = WksCustomDio.withAuthentication().instance;
  late TodoDatasource datasource;
  late TodoRepository repository;
  late GetTodoAll search;
  late UpdateTodoById updatetodo;
  late TodoHomeBloc bloc; //var searchBloc = SearchBloc();
  late GlobalKey refreshKey;
  late TodoOptionsModel _optionsModel;
  late TodoOptionsBloc _todoOptionsBloc;
  late bool _showFilters;
  late TodoItemsController _todoItemsController;
  late TodoUpdateBloc _updateBloc;
  late UpdateTodoMulti _updateTodoMulti;
  late TodoUpdateMultiBloc _updateMultiBloc;

  @override
  void initState() {
    super.initState();
    // First Step DEFAULT (order and filters options)
    _optionsModel = TodoOptionsModel(
      filter: TodoFilters.filterAll,
      order: TodoOrders.normalDesc,
      group: TodoGroups.groupAll,
    );
    _showFilters = false;
    // items manager
    _todoItemsController = TodoItemsController(todosStatus: []);
    // Options via bloc
    _todoOptionsBloc =
        new TodoOptionsBloc(todoOptionsState.SuccessState(_optionsModel));
    // Blocs and repositories
    refreshKey = GlobalKey<RefreshIndicatorState>();
    datasource = EIAPITodoDatasource(dio);
    repository = TodoRepositoryImpl(datasource);

    // link update with repository
    updatetodo = UpdateTodoByIdImpl(repository);
    _updateBloc = TodoUpdateBloc(updatetodo);

    // link updateMultiBloc with repository
    _updateTodoMulti = UpdateTodoMultiImpl(repository);
    _updateMultiBloc = TodoUpdateMultiBloc(_updateTodoMulti);

    search = GetTodoAllImpl(repository);
    bloc = TodoHomeBloc(search);
    bloc.add(1);
    selectedTodo = [];
    _nextRefreshElimiteStatus = [];

    _filter = '';
    _searchTextController.addListener(() {
      debugPrint('f7087 - _searchTextController.text start listener');
      _filter = _searchTextController.text;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MyLayout(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.5),
          title: Text('Anotações pessoais'),
        ),
        bottomNavigationBar: _showMenu(),
        floatingActionButton: FloatingActionButton(
            child: Icon(selectedTodo.length == 0 ? Icons.add : Icons.close),
            onPressed: () async {
              //_navigateAddPage(context);
              if (selectedTodo.length == 0) {
                debugPrint('f7882 - Runnning todoAdd');
                List<TodoModel>? todosAdded =
                    await showModalBottomSheet<List<TodoModel>>(
                        context: context,
                        builder: (BuildContext context) {
                          return TodoAdd();
                        });
                todosAdded!.forEach((i) => debugPrint(
                    'f7882 - complete todoAdd with info: ' +
                        i.description.toString()));
              } else {
                setState(() {
                  selectedTodo.clear();
                });
              }
            }),
        body: Column(children: [
          TodoSync(
            updateBloc: _updateBloc,
            multiUpdateBloc: _updateMultiBloc,
          ),
          WidgetPageTitle(
              title: 'Relação geral',
              workspace: app_selected_workspace_name,
              context: context,
              onTap: () async {
                await refreshList();
              }).render(),
          WidgetPageFilterInput(
            searchTextController: _searchTextController,
            context: context,
          ),
          Row(children: [
            _showFiltersChips(),
            const Spacer(),
            Container(
                child: OptionsTodoButton(
              optionsModel: _optionsModel,
              optionsBloc: _todoOptionsBloc,
            )),
          ]),
          Expanded(
            flex: 1,
            child: StreamBuilder(
                stream: _todoOptionsBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final state = _todoOptionsBloc.state;
                    if (state == todoOptionsState.ErrorState) {
                      return Container();
                    } else if (state == todoOptionsState.StartState) {
                      return Container();
                    } else if (state == todoOptionsState.LoadingState) {
                      return Container();
                    } else {
                      debugPrint(
                          'f8752 - ' + _todoOptionsBloc.state.toString());
                      debugPrint('f8752 - Here has the data');

                      final options =
                          (state as todoOptionsState.SuccessState).options;
                      debugPrint(
                          'f8752 - Filter = ${options.filter!.displayTitle}');
                      debugPrint(
                          'f8752 - Group = ${options.group!.displayTitle}');
                      debugPrint(
                          'f8752 - Order = ${options.order!.displayTitle}');
                      // If changes, do refresh
                      if (options.filter != _optionsModel.filter ||
                          options.group != _optionsModel.group ||
                          options.order != _optionsModel.order) {
                        _optionsModel = options;
                        debugPrint('f8752 - done');
                        Future(() async {
                          debugPrint(
                              'f8752 - Need rebuild state ------------------');
                          _rebuildView();
                          _refreshState();
                        });
                        _showFilters = true;
                        return Container();
                      }
                    }
                    return Container();
                  }
                  return Container();
                }),
          ),
          Expanded(
              flex: 10,
              child: RefreshIndicator(
                key: refreshKey,
                onRefresh: () async {
                  await refreshList();
                },
                child: _listStream(),
              )),
          Expanded(flex: 1, child: _streamWaitMultiDone()),
        ]),
      ),
    );
  }

  _showFiltersChips() {
    if (_showFilters) {
      return Wrap(
        spacing: 5,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Chip(
              onDeleted: _optionsModel.group == TodoGroups.groupAll
                  ? null
                  : () {
                      setState(() {
                        _optionsModel.group = TodoGroups.groupAll;
                        _rebuildView();
                      });
                    },
              padding: EdgeInsets.all(8),
              label: Text('${_optionsModel.group!.displayTitle}',
                  style: TextStyle(fontSize: 10))),
          Chip(
              onDeleted: _optionsModel.order == TodoOrders.normalDesc
                  ? null
                  : () {
                      setState(() {
                        _optionsModel.order = TodoOrders.normalDesc;
                        _rebuildView();
                      });
                    },
              padding: EdgeInsets.all(8),
              label: Text('${_optionsModel.order!.displayTitle}',
                  style: TextStyle(fontSize: 10))),
          Chip(
              onDeleted: _optionsModel.filter == TodoFilters.filterAll
                  ? null
                  : () {
                      setState(() {
                        _optionsModel.filter = TodoFilters.filterAll;
                        _rebuildView();
                      });
                    },
              padding: EdgeInsets.all(8),
              label: Text('${_optionsModel.filter!.displayTitle}',
                  style: TextStyle(fontSize: 10))),
        ],
      );
    } else {
      return Container();
    }
  }

  // rebuild all views aspects (applying filters, orders and groups)
  Future<Null> _rebuildView() async {
    //
  }

  Future<Null> refreshList() async {
    // If selection to eliminate, do here
    if (_nextRefreshElimiteStatus.length > 0) {
      _nextRefreshElimiteStatus.forEach((element) {
        _todoItemsController.removeStatus(
          todoid: element,
        );
      });
      _nextRefreshElimiteStatus.clear();
    }
    // Process
    bloc.add(1);
    await Future.delayed(Duration(milliseconds: 100));
  }

  Future<void> _refreshState() async {
    setState(() {});
  }

  Widget _listStream() {
    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('f7047 - Uma info na stream TODO-HOME...');
            final state = bloc.state;
            if (state is StartState) {
              return Center(child: Text(''));
            } else if (state is ErrorState) {
              debugPrint('f7047 - Error state, done');
              return WidgetNeedRefreshError(
                title: state.error.toString(),
                workspace: app_selected_workspace_name,
                onTap: () {
                  setState(() {
                    refreshList();
                  });
                },
                context: context,
              );
            } else if (state is LoadingState) {
              return progressBar(context);
            } else {
              final list = _aplicaGrupo(_aplicaOrdem(_aplicaFiltro(
                  (state as SuccessState).list as List<TodoModel>)));

              debugPrint('f7047 - Ajusta status inicial da lista');
              int i = 0;
              list.forEach((element) {
                if (element.todoid != null) {
                  /*if (![StatusRecord.stDeletedDone,
                  StatusRecord.stDeleted,
                  StatusRecord.stMarkAsFinished,
                  StatusRecord.stMarkAsUnfinished,
                  Stat].contains(_todoItemsController.getStatus(element.todoid))) {
                    _todoItemsController.addStatus(
                        todoid: element.todoid,
                        status: StatusRecord.stDataRecord,
                        todoModel: element);
                  }*/
                }
              });

              debugPrint('f7047 - Size = ' + list.length.toString());
              debugPrint('f7047 - done');

              //List list = (state as SuccessState).list;

              return _widgetShowList(list);
            }
          } else {
            debugPrint('f7047 - done');
            return Container();
          }
        });
  }

  List<TodoModel> _aplicaFiltro(List<TodoModel> list) {
    List<TodoModel> newList = [];
    if (_optionsModel.filter == TodoFilters.filterFinished) {
      newList = list.where((i) => i.finished!).toList();
    }
    if (_optionsModel.filter == TodoFilters.filterUnfinished) {
      newList = list.where((i) => !i.finished!).toList();
    }
    if (_optionsModel.filter == TodoFilters.filterAll) {
      newList = list;
    }
    // And _filter (text)
    if (_filter.isNotEmpty) {
      debugPrint('f7812 - filter = "' +
          _filter +
          '" initial records' +
          list.length.toString());
      newList = newList
          .where((element) =>
              element.description!.contains(_filter) ||
              element.description!
                  .toLowerCase()
                  .contains(_filter.toLowerCase()))
          .toList();
    }
    return newList;
  }

  List<TodoModel> _aplicaGrupo(List<TodoModel> list) {
    if (_optionsModel.group == TodoGroups.groupAll) {
      return list;
    }
    List<TodoModel> newList = [];
    if (_optionsModel.group == TodoGroups.groupStatus) {
      newList = _applyGroupStatus(list);
    } else if (_optionsModel.group == TodoGroups.groupDate) {
      newList = _applyGroupDate(list);
    }
    return newList;
  }

  // Agrupamento por Status
  List<TodoModel> _applyGroupStatus(List<TodoModel> list) {
    List<TodoModel> newList = [];
    String _lastHeader = '';
    int i = 0;
    list.forEach((element) {
      if (i == 0) {
        _lastHeader = element.finished.toString();
        newList.add(TodoModel(
            status: StatusRecord.stCabecalho,
            description:
                element.finished! ? kTitleFinished : kTitleUnfinished));
      } else {
        if (_lastHeader != element.finished.toString()) {
          _lastHeader = element.finished.toString();
          newList.add(TodoModel(
              status: StatusRecord.stCabecalho,
              description:
                  element.finished! ? kTitleFinished : kTitleUnfinished));
        }
      }
      ++i;
      element.status = StatusRecord.stDataRecord;
      newList.add(element);
    });
    return newList;
  }

  // Agrupamento por Data
  List<TodoModel> _applyGroupDate(List<TodoModel> list) {
    List<TodoModel> newList = [];
    String _lastHeader = '';
    int i = 0;
    list.forEach((element) {
      if (i == 0) {
        _lastHeader = element.dateadded.toString();
        newList.add(TodoModel(
            status: StatusRecord.stCabecalho,
            description: '$kTitleDay ${element.dateadded}'));
      } else {
        if (_lastHeader != element.dateadded.toString()) {
          _lastHeader = element.dateadded.toString();
          newList.add(TodoModel(
              status: StatusRecord.stCabecalho,
              description: '$kTitleDay ${element.dateadded}'));
        }
      }
      ++i;
      element.status = StatusRecord.stDataRecord;
      newList.add(element);
    });
    return newList;
  }

  List<TodoModel> _aplicaOrdem(List<TodoModel> list) {
    if (_optionsModel.order == TodoOrders.dateAsc) {
      list.sort((a, b) {
        return (a.dateadded! + a.timeadded!)
            .toString()
            .toLowerCase()
            .compareTo((b.dateadded! + b.timeadded!).toString().toLowerCase());
      });
    }
    if (_optionsModel.order == TodoOrders.dateDesc) {
      list.sort((a, b) {
        return (b.dateadded! + b.timeadded!)
            .toString()
            .toLowerCase()
            .compareTo((a.dateadded! + b.timeadded!).toString().toLowerCase());
      });
    }
    if (_optionsModel.order == TodoOrders.normalAsc) {
      list.sort((a, b) {
        return a.todoid!.toInt().compareTo(b.todoid!.toInt());
      });
    }
    if (_optionsModel.order == TodoOrders.normalDesc) {
      list.sort((a, b) {
        return b.todoid!.toInt().compareTo(a.todoid!.toInt());
      });
    }
    if (_optionsModel.order == TodoOrders.statusAsc) {
      list.sort((a, b) {
        return a.finished
            .toString()
            .toLowerCase()
            .compareTo(b.finished.toString().toLowerCase());
      });
    }
    if (_optionsModel.order == TodoOrders.statusDesc) {
      list.sort((a, b) {
        return b.finished
            .toString()
            .toLowerCase()
            .compareTo(a.finished.toString().toLowerCase());
      });
    }
    return list;
  }

  _widgetShowList(var list) {
    return Container(
      height: MediaQuery.of(context).size.height - (_showFilters ? 320 : 220),
      child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: list.length,
          itemBuilder: (_, id) {
            final item = list[id];
            // todo: correct this
            if (item.finished == null) {
              return _listHeader(item.description);
            } else if (item.status == StatusRecord.stCabecalho) {
              return _listHeader(item.description);
            } else {
              return _itemContent(item);
            }
          }),
    );
  }

  _listHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
      child: Container(child: Text(title, style: TextStyle(fontSize: 16))),
    );
  }

  _itemContent(TodoModel item) {
    var cor = Theme.of(context).colorScheme.background;
    if (_todoItemsController.getStatus(item.todoid) == StatusRecord.stChanged)
      cor = Colors.black12;
    TodoModel customItem = item;
    TodoItemStatus _todoItemStatus;
    _todoItemStatus = TodoItemStatus();
    _todoItemStatus.status = _todoItemsController.getStatus(item.todoid);
    // If datamodel has informations,
    // get data from _todoItemStatus.todoModel.
    if (customItem.status != StatusRecord.stCabecalho) {
      if (_todoItemStatus != null) {
        if (_todoItemStatus.todoModel != null) {
          if (_todoItemStatus.todoModel!.description != null) {
            customItem.description = _todoItemStatus.todoModel!.description;
          }
        }
      }
    }

    if (_todoItemStatus == null) {
      _todoItemStatus.status = StatusRecord.stDataRecord;
    } else if (_todoItemStatus.status == StatusRecord.stDeletedDone) {
      debugPrint('f7405 - Deleted done detected, icon dif in ' +
          customItem.todoid.toString());
    } else {
      debugPrint('f7405 - ' + _todoItemStatus.status.toString());
    }

    Icon iconLeft;
    if (_todoItemStatus.status == StatusRecord.stDeletedDone) {
      iconLeft = Icon(Icons.close, color: Colors.red);
    } else if (_todoItemStatus.status == StatusRecord.stMarkAsUnfinishedDone ||
        _todoItemStatus.status == StatusRecord.stMarkAsUnfinished) {
      iconLeft = Icon(
        Icons.circle_outlined,
        color: Colors.green,
      );
    } else if (_todoItemStatus.status == StatusRecord.stMarkAsFinishedDone ||
        _todoItemStatus.status == StatusRecord.stMarkAsFinished) {
      iconLeft = Icon(Icons.check_circle,
          color: Theme.of(context).colorScheme.onPrimary.withAlpha(100));
    } else {
      if (customItem.finished!) {
        iconLeft = Icon(Icons.check_circle,
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(200));
      } else
        iconLeft = Icon(
          Icons.circle_outlined,
          color: Colors.green,
        );
    }
    Widget _widgetActionLeft = Container(
      width: 50,
      height: 50,
      child: Align(alignment: Alignment.topCenter, child: iconLeft),
    );

    return Hero(
        tag: kheroTodoEdit + customItem.todoid.toString(),
        child: Material(
          child: ListTile(
            tileColor: cor,
            leading: InkWell(
              child: _widgetActionLeft,
              onTap: () {
                TodoItemsController _tmpController;
                _tmpController = TodoItemsController(todosStatus: []);
                final _tmpStatusAtual =
                    (_todoItemsController.getStatus(customItem.todoid));
                if (_tmpStatusAtual == StatusRecord.stMarkAsFinishedDone ||
                    _tmpStatusAtual == StatusRecord.stMarkAsFinished) {
                  _todoItemsController.addStatus(
                      todoid: customItem.todoid!,
                      status: StatusRecord.stMarkAsUnfinished);
                  _tmpController.addStatus(
                      todoid: customItem.todoid!,
                      status: StatusRecord.stMarkAsUnfinished);
                } else {
                  _todoItemsController.addStatus(
                      todoid: customItem.todoid!,
                      status: StatusRecord.stMarkAsFinished);
                  _tmpController.addStatus(
                      todoid: customItem.todoid!,
                      status: StatusRecord.stMarkAsFinished);
                }
                // Update window
                setState(() {});
                // Executa o processo via bloc
                if (_tmpController.list.length > 0) {
                  _updateMultiBloc.add(_tmpController);
                }
              },
            ),
            selected: selectedTodo.indexOf(customItem.todoid!) >= 0,
            title: Text(
              '${customItem.description}',
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8),
              child: Text(
                '${customItem.dateadded.toString()} às ${customItem.timeadded.toString()}, #${item.todoid.toString()}',
                style: TextStyle(fontSize: 11),
              ),
            ),
            onLongPress: () {
              if (![StatusRecord.stDeleted, StatusRecord.stDeletedDone]
                  .contains(_todoItemStatus.status)) {
                if (selectedTodo.indexOf(customItem.todoid!) >= 0) {
                  _itemremove(customItem.todoid!);
                } else {
                  _itemadd(customItem.todoid!);
                }
              }
            },
            onTap: () async {
              _editBox(customItem);
            },
          ),
        ));
  }

  _itemadd(int i) async {
    setState(() {
      selectedTodo.add(i);
    });
  }

  _itemremove(int i) async {
    setState(() {
      selectedTodo.remove(i);
    });
  }

  _editBox(TodoModel todo) async {
    TodoModel customItem = todo;
    debugPrint(
        'f7854 - Acessando TodoEditPopupCard (item:${customItem.todoid.toString()}');
    var resultado =
        await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return TodoEditPopupCard(
        todoModel: customItem,
      );
    }));

    if (resultado != null) {
      debugPrint('f7854 - Response: ' + resultado.toString());
      customItem.status = StatusRecord.stChanged;
      customItem.description = resultado.toString();
      _todoItemsController.addStatus(
          todoid: customItem.todoid!,
          status: StatusRecord.stChanged,
          todoModel: customItem);
      // todoAdjust to get id to dynamic
      int iPos = _todoItemsController.getPos(customItem.todoid!);
      debugPrint('f7854 - iPos: ' + iPos.toString());
      if (iPos >= 0) {
        //_todoItemsController.todosStatus[iPos]
        //    .setTodo(TodoModel(description: resultado.toString()));
        _updateBloc.add(TodoModel(
            todoid: customItem.todoid, description: resultado.toString()));
      }
      _todoOptionsBloc.add(_optionsModel);
    }
    setState(() {});
    return Container();
  }

  _boxSpecial(int i) async {
    debugPrint('Modal=>CoursesUpdate:Start');
    bool lStatus = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(); //CoursesUpdate(id: selectedTodo[0]);
        }).whenComplete(() => debugPrint('Modal=>ContactSearchWidget:End'));
    debugPrint('Modal=>CoursesCoursesUpdate:Result=>${lStatus.toString()}');
    bloc.add(1);
    return Container();
  }

  Future _futureRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshState();
    setState(() {
      _rebuildView();
    });
  }

  _showMenu() {
    debugPrint('menu');
    if (selectedTodo.length > 0) {
      return Container(
        height: 50,
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
              ),
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.delete),
                  ),
                  onTap: () async {
                    if (await TodoRemoveConfirmation().confirm(context) ==
                        true) {
                      TodoItemsController _tmpController;
                      _tmpController = TodoItemsController(todosStatus: []);
                      selectedTodo.forEach((element) {
                        if (element > 0) {
                          _tmpController.addStatus(
                              todoid: element, status: StatusRecord.stDeleted);
                        }
                      });
                      // Executa o processo via bloc
                      if (_tmpController.list.length > 0) {
                        _updateMultiBloc.add(_tmpController);
                      }
                      setState(() {});
                      _futureRefresh();
                    }
                  }),
              const Spacer(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.refresh),
                ),
                onTap: () {
                  setState(() {
                    _rebuildView();
                  });
                },
              ),
              selectedTodo.length == 1
                  ? GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.edit)),
                      onTap: () {
                        TodoModel customItem;
                        TodoItemStatus _todoItemStatus =
                            _todoItemsController.getById(selectedTodo[0]);
                        customItem = _todoItemStatus.todoModel!;
                        customItem.status = _todoItemStatus.status;
                        // If datamodel has informations,
                        // get data from _todoItemStatus.todoModel.
                        if (customItem.status == null) {
                          customItem.status = StatusRecord.stDataRecord;
                        }
                        if (customItem.status != StatusRecord.stCabecalho) {
                          if (_todoItemStatus != null) {
                            if (_todoItemStatus.todoModel != null) {
                              if (_todoItemStatus.todoModel!.description !=
                                  null) {
                                customItem.description =
                                    _todoItemStatus.todoModel!.description;
                              }
                            }
                          }
                        }
                        _editBox(customItem);
                        setState(() {});
                      })
                  : Container(),
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.checklist_rounded),
                  ),
                  onTap: () async {
                    TodoItemsController _tmpController;
                    _tmpController = TodoItemsController(todosStatus: []);
                    selectedTodo.forEach((element) {
                      if (element > 0) {
                        _tmpController.addStatus(
                            todoid: element,
                            status: StatusRecord.stMarkAsFinished);
                      }
                    });
                    // Executa o processo via bloc
                    if (_tmpController.list.length > 0) {
                      _updateMultiBloc.add(_tmpController);
                    }
                    setState(() {});
                  }),
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.undo_rounded,
                    ),
                  ),
                  onTap: () async {
                    if (await TodoUndoConfirmation().confirm(context) == true) {
                      TodoItemsController _tmpController;
                      _tmpController = TodoItemsController(todosStatus: []);
                      selectedTodo.forEach((element) {
                        if (element > 0) {
                          _tmpController.addStatus(
                              todoid: element,
                              status: StatusRecord.stMarkAsUnfinished);
                        }
                      });
                      // Executa o processo via bloc
                      if (_tmpController.list.length > 0) {
                        _updateMultiBloc.add(_tmpController);
                      }
                      setState(() {});
                    }
                  }),
              Container(
                width: 30,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  _streamWaitMultiDone() {
    if (_updateMultiBloc == null) {
      return Container();
    } else {
      return StreamBuilder(
          stream: _updateMultiBloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              debugPrint(
                  'f5052 - todo_sync say: Opa! Uma info na stream TODO/UPDATEMULTI...');
              final state = _updateMultiBloc.state;
              if (state is multiupdate_state.StartState) {
                return Container(); //Center(child: Text(''));
              } else if (state is multiupdate_state.ErrorState) {
                return Container();
                //return Center(
                //    child: Text('Erro ao executar:' + state.error.toString()));
              } else if (state is multiupdate_state.LoadingState) {
                return Container();
                //return Center(
                //  child: progressBar(context),
                // );
              } else {
                final List<TodoModel> list =
                    ((state as multiupdate_state.SuccessState).list)
                        as List<TodoModel>;

                debugPrint(
                    'f5052 - Do update Size = ' + list.length.toString());
                list.forEach((element) {
                  if (element == null) {
                    debugPrint('f5052 - Element unknow');
                  } else {
                    if (element.status == null) {
                      debugPrint(
                          'f5052 - Status unknow ' + element.todoid.toString());
                    } else if (element.status ==
                        StatusRecord.stMarkAsFinishedDone) {
                      debugPrint(
                          'f5052 - Finished now ' + element.todoid.toString());
                      // Set status to update window
                      _todoItemsController.addStatus(
                        todoid: element.todoid!,
                        status: StatusRecord.stMarkAsFinishedDone,
                      );
                    } else if (element.status ==
                        StatusRecord.stMarkAsUnfinishedDone) {
                      debugPrint(
                          'f5052 - Finished now ' + element.todoid.toString());
                      // Set status to update window
                      _todoItemsController.addStatus(
                        todoid: element.todoid!,
                        status: StatusRecord.stMarkAsUnfinishedDone,
                      );
                    } else if (element.status == StatusRecord.stDeletedDone) {
                      debugPrint(
                          'f5052 - Deleted now ' + element.todoid!.toString());
                      // Set status to update window
                      _todoItemsController.addStatus(
                        todoid: element.todoid!,
                        status: StatusRecord.stDeletedDone,
                      );
                      _itemremove(element.todoid!);
                      _nextRefreshElimiteStatus.add(element.todoid!);
                    } else if (element.status == StatusRecord.stDeleted) {
                      debugPrint('f5052 - Programado para deletar ' +
                          element.todoid.toString());
                      _itemremove(element.todoid!);
                      _nextRefreshElimiteStatus.add(element.todoid!);
                    }
                  }
                });
                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text("Atualização de multiplos itens concluída"),
                // ));

                // this is to do after
                // error -> refreshState();

                return Container();
              }
            } else {
              return Container();
            }
          });
    }
  }
}
