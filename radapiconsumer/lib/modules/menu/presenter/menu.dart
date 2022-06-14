import 'dart:io';
import 'dart:math';

import '/modules/element/domain/entities/element_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/core/constants/kversion.dart';
import '/global/resources/kconstants.dart';
import '/modules/element/domain/repositories/elements_repository.dart';
import '/modules/element/domain/usecases/get_by_index.dart';
import '/modules/element/external/memory/ei_elements_memory_datasource.dart';
import '/modules/element/infra/datasources/element_datasource.dart';
import '/modules/element/infra/models/element_model.dart';
import '/modules/element/infra/repositories/element_repository_impl.dart';
import '/utils/globals.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/modules/menu/presenter/menu_item.dart';

import '../../../routes.dart';
import 'menu_bloc.dart';
import 'myclipper.dart';
import 'states/element_menu_state.dart';

bool closeTopContainer = false;

class Menu extends StatefulWidget {
  Widget? start;

  Menu({
    Key? key,
    this.start,
  }) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List selectedIndexes = [];
  List removedIndexes = [];
  List<ElementModel> _listMenu = [];
  final listKey = GlobalKey<AnimatedListState>();

  late ElementDatasource datasource;
  late ElementsRepository repository;
  late GetByIndex search;
  late MenuBloc bloc;
  late GlobalKey refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datasource = EIElementsMemoryDatasource();
    repository = ElementRepositoryImpl(datasource);
    search = GetByIndexImpl(repository);
    bloc = MenuBloc(search);
    //if (app_userkey == '') {
    //  bloc.add(kMenuGetInstallOptions);
    //} else {
    //bloc.add(kMenuGetMenuDefaultOptions);
    //}
    refreshKey = refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  // todo: valmor: esta configuraçao deve rodar 1x ao iniciar,
  // mas, esta desativa pois em modo debug ta dando erro
  // no android - Antes isso estava no initState
  configureState() {
    //
    setState(() {
      if (kIsWeb) {
      } else {
        if (Platform.isAndroid) {
          // Hiden header only if necessary
          if (MediaQuery.of(context).size.height < 2048) {}
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return render(context, bloc, refreshKey);
  }

  Widget render(BuildContext context, bloc, refreshKey) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await refreshList(bloc);
            },
            child: (widget.start != null)
                ? Column(children: [
                    widget.start!,
                    StreamBuilder(
                      stream: bloc.stream,
                      builder: (context, snapshot) {
                        return _menuMount(bloc, context, snapshot);
                      },
                    ),
                  ])
                : StreamBuilder(
                    stream: bloc.stream,
                    builder: (context, snapshot) {
                      return _menuMount(bloc, context, snapshot);
                    },
                  )));

    /*default-> return SingleChildScrollView(
      child: StreamBuilder(
        stream: bloc,
        builder: (context, snapshot) {
          return _menuMount(bloc, context, snapshot);
        },
      ),
    );
    */
  }

  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  Widget _menuMount(bloc, context, snapshot) {
    if (snapshot.hasData) {
      debugPrint('f4021 - Opa! Uma info MENU na stream...');
      final state = bloc.state;
      if (state is StartState) {
        return progressBar(context);
      } else if (state is ErrorState) {
        return Center(
            child: Text('Erro ao executar:' + state.error.toString()));
      } else if (state is LoadingState) {
        return progressBar(context);
      } else {
        _listMenu = ((state as SuccessState).list as List<ElementModel>);
        return Column(children: [
          Visibility(
              visible: isSelectedItem, child: _headerCommands(bloc, context)),
          Visibility(
            visible: !isInstalled,
            child: Container(
                color: Colors.amber,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(children: [
                    Container(
                        width: double.infinity,
                        color: Colors.amber,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Container(
                            child: Text(
                                'Você ainda não se identificou no sistema. Conclua a instalação para poder usar todos os recursos.'),
                          ),
                        )),
                    TextButton(
                        child: Text('CLIQUE AQUI PARA INICIAR'),
                        onPressed: () {
                          if (!isInstalled) {
                            Navigator.pushNamed(context, Routes.login_google);
                          } else {}
                        }),
                    const SizedBox(height: 30),
                  ]),
                )),
          ),
          /*!app_invite_accepted
              ? InviteComponent(
                  host: 'Valmor Flores',
                  workspace: 'cosems.rs',
                  paper: 'Desenvolvedor')
              : Container(),*/

          Visibility(
            visible: !isSelectedItem,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 50),
              child: _header(bloc, context),
              height: closeTopContainer
                  ? 0
                  : MediaQuery.of(context).size.height * 0.25,
            ),
          ),
          Container(
              height: closeTopContainer
                  ? MediaQuery.of(context).size.height * 0.75
                  : MediaQuery.of(context).size.height * 0.60,
              child: AnimatedList(
                  key: listKey,
                  initialItemCount: _listMenu.length,
                  itemBuilder: (context, id, animation) {
                    final item = _listMenu[id];
                    return SlideTransition(
                        position: animation.drive(_offset),
                        child: buildItem(
                            bloc: bloc,
                            item: item,
                            index: id,
                            animation: animation));
                  })),
        ]);
      }
    } else {
      return progressBar(context);
    }
  }

  bool get isSelectedItem {
    bool _selectedItem = false;
    _listMenu.forEach((element) {
      if (element.selected!) {
        _selectedItem = true;
      }
    });
    return _selectedItem;
  }

  // Box of commands if selecteds
  Widget _headerCommands(bloc, context) {
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          debugPrint('clear');
          selectedIndexes.clear();
          bloc.add(1);
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 200,
            color: Theme.of(context).dialogBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(children: [
                  Expanded(child: Container()),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close),
                    ),
                    onTap: () {
                      selectedIndexes.clear();
                      bloc.add(1);
                    },
                  )
                ]),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.access_alarm),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.attach_file),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.folder_open_sharp),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.clear_all),
                    ),
                    GestureDetector(
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.delete),
                      ),
                      onTap: () {
                        _listMenu.forEach((element) {
                          //removedIndexes.add(element);
                          if (element.selected!) {
                            removeItem(bloc: bloc, index: element.index!);
                          }
                        });
                        //selectedIndexes.clear();
                        //bloc.add(1);
                      },
                    ),
                  ],
                ),
                selectedIndexes.length == 1
                    ? Row(
                        children: [
                          GestureDetector(
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.add,
                              ),
                            ),
                            onTap: () {
                              debugPrint('Add ' + selectedIndexes.toString());
                              if (selectedIndexes.toString() == '[7]') {
                                Navigator.pushNamed(
                                    context, Routes.courses_add);
                                debugPrint(Routes.courses_add);
                              }
                            },
                          ),
                        ],
                      )
                    : Container(),
              ]),
            )));
  }

  void removeItem({required MenuBloc bloc, required int index}) {
    final item = _listMenu.removeAt(index);
    listKey.currentState?.removeItem(
        index,
        (context, animation) => buildItem(
            bloc: bloc, item: item, index: index, animation: animation));
  }

  void clickItem({required bloc, required context, required int index}) async {
    ElementModel item = _listMenu[index];

    if (selectedIndexes.length > 0) {
      //selectItem(item.index);
      //bloc.add(1);
    } else {
      if (item.route != null) {
        if (item.wait!) {
          debugPrint('f4020 - Running route with await...');
          await Navigator.pushNamed(context, item.route!);
          if (item.refreshApp!) {
            debugPrint('f4020 - Done, refreshing app...');
            // todo: valmor: analise if email ok?
            item.checked = true;
            // reload menu
            bloc.add(1);
            // refresh app
            Get.appUpdate();
          }
        } else {
          debugPrint('f4020 - Normal async pushnamed' + item.route.toString());
          Navigator.pushNamed(context, item.route!);
        }
      } else {
        if (item.checked == null) {
          debugPrint('f4020 - Route:' + item.route.toString());
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Esta opção está indisponível no momento')));
        } else if (item.checked!) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Esta opção ou etapa já foi realizada')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Este recurso esta momentaneamente indisponível ao seu perfil')));
        }
      }
    }
  }

  Widget buildItem(
          {required bloc,
          required item,
          required int index,
          required Animation<double> animation}) =>
      MenuOption(
        bloc: bloc,
        item: item,
        animation: animation,
        onRemoveClick: () {},
        onClick: () {
          clickItem(bloc: bloc, context: context, index: index);
        },
        onLongPress: () {
          selectItem(index: index);
        },
      );

  selectItem({index}) {
    _listMenu[index].selected = !(_listMenu[index].selected!);
    debugPrint('f8025 - long press:' + index.toString());
    setState(() {});
  }

  Widget _header(bloc, context) {
    return Container(
      height: 200,
      child: Stack(children: [
        ClipPath(
          clipper: MyClipper(),
          child: Container(
              height: 170,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 42,
                          left: 10,
                          child: Text(
                              app_selected_workspace_name != ''
                                  ? app_selected_workspace_name
                                  : 'eiApp',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 48,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white)),
                        ),
                        const Positioned(
                          top: 96,
                          left: 10,
                          child: Text(kVersion,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
        closeTopContainer
            ? Container()
            : Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width - 50, 50, 0, 0),
                child: Container(
                    color: Colors.transparent,
                    width: 100,
                    height: 100,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.settings);
                        },
                        child: Icon(Icons.settings_outlined))),
                /* */
              ),
        (app_game_mode == 0)
            ? SizedBox(width: 10)
            : Row(
                children: [
                  const SizedBox(width: 200),
                  Transform.rotate(
                      angle: pi / 9,
                      child: Icon(Icons.sports_esports,
                          size: 128, color: Colors.white.withAlpha(70))),
                  const Spacer(),
                ],
              )
      ]),
    );
  }

  Future<Null> refreshList(bloc) async {
    if (app_selected_workspace_name != null) {
      if (app_selected_workspace_name != '') {
        debugPrint(
            'f5622 - Refreshing informations for workspace enabled and selected');
        bloc.add(kMenuGetMenuDefaultOptions);
      } else {
        debugPrint('f5622 - Refreshing informations with default menu');
        bloc.add(1);
      }
    } else {
      debugPrint('f5622 - Refreshing informations with default menu');
      bloc.add(1);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('f5622 - Refreshing done');
  }
}
