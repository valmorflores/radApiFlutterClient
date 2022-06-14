import '../../infra/blocs/todo_options_bloc.dart';
import 'package:flutter/material.dart';

import '/modules/todo/domain/utils/enum_todo_filters.dart';
import '/modules/todo/domain/utils/enum_todo_groups.dart';
import '/modules/todo/domain/utils/enum_todo_orders.dart';
import '/modules/todo/infra/models/todo_options_model.dart';

import '../../../../utils/dialog/hero_dialog_route.dart';

/// Tag-value used for the add todo popup button.
const String _heroOptionsTodo = 'todo-filter';

/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_OptionsTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroOptionsTodo].
/// {@endtemplate}
class OptionsTodoButton extends StatefulWidget {
  TodoOptionsModel optionsModel;
  TodoOptionsBloc optionsBloc;

  /// {@macro add_todo_button}
  OptionsTodoButton(
      {Key? key, required this.optionsModel, required this.optionsBloc})
      : super(key: key);

  @override
  State<OptionsTodoButton> createState() => _OptionsTodoButtonState();
}

class _OptionsTodoButtonState extends State<OptionsTodoButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            debugPrint(
                'f9122 - Filter: ' + widget.optionsModel.filter!.displayTitle);
            debugPrint(
                'f9122 - Order: ' + widget.optionsModel.order!.displayTitle);
            debugPrint(
                'f9122 - Group: ' + widget.optionsModel.group!.displayTitle);
            return _OptionsTodoPopupCard(
              optionsModel: widget.optionsModel,
              optionsBloc: widget.optionsBloc,
            );
          }));
        },
        child: Hero(
          tag: _heroOptionsTodo,
          child: Material(
            elevation: 0,
            child: const Icon(
              Icons.menu,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroOptionsTodo].
/// {@endtemplate}
class _OptionsTodoPopupCard extends StatefulWidget {
  TodoOptionsModel optionsModel;
  TodoOptionsBloc optionsBloc;

  /// {@macro add_todo_popup_card}
  _OptionsTodoPopupCard({
    Key? key,
    required this.optionsModel,
    required this.optionsBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OptionsTodoPopupCardState();
}

class _OptionsTodoPopupCardState extends State<_OptionsTodoPopupCard> {
  late TodoGroups _selectedGroups;

  late TodoFilters _selectedFilters;

  late TodoOrders _selectedOrders;

  @override
  void initState() {
    super.initState();
    _selectedFilters = widget.optionsModel.filter!;
    _selectedOrders = widget.optionsModel.order!;
    _selectedGroups = widget.optionsModel.group!;
    debugPrint('f9700 - Filter: ' + widget.optionsModel.filter!.displayTitle);
    debugPrint('f9700 - Order: ' + widget.optionsModel.order!.displayTitle);
    debugPrint('f9700 - Group: ' + widget.optionsModel.group!.displayTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroOptionsTodo,
          child: Material(
            color: Theme.of(context).colorScheme.background,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 260,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text('Agrupamento'),
                            subtitle: Text(_selectedGroups.displayTitle,
                                style: TextStyle(fontSize: 11)),
                            trailing: null,
                            onTap: () {
                              if (_selectedGroups == TodoGroups.groupAll)
                                _selectedGroups = TodoGroups.groupDate;
                              else if (_selectedGroups == TodoGroups.groupDate)
                                _selectedGroups = TodoGroups.groupDateFinished;
                              else if (_selectedGroups ==
                                  TodoGroups.groupDateFinished)
                                _selectedGroups = TodoGroups.groupStatus;
                              else if (_selectedGroups ==
                                  TodoGroups.groupStatus)
                                _selectedGroups = TodoGroups.groupAll;
                              setState(() {
                                debugPrint(_selectedGroups.toString());
                              });
                            },
                          ),
                          ListTile(
                            title: Text('Ordem'),
                            subtitle: Text(
                              _selectedOrders.displayTitle,
                              style: TextStyle(fontSize: 11),
                            ),
                            trailing: InkWell(
                              child: Container(
                                child: _selectedOrders.isOrderDesc
                                    ? Icon(Icons.arrow_circle_down)
                                    : Icon(Icons.arrow_circle_up),
                              ),
                              onTap: () {
                                debugPrint('f9707 - Tap on icon');
                                _selectedOrders = _selectedOrders.inverse;
                                setState(() {
                                  debugPrint(_selectedFilters.toString());
                                });
                              },
                            ),
                            onTap: () {
                              // Asc
                              if (_selectedOrders == TodoOrders.normalAsc) {
                                _selectedOrders = TodoOrders.dateAsc;
                              } else if (_selectedOrders ==
                                  TodoOrders.dateAsc) {
                                _selectedOrders = TodoOrders.statusAsc;
                              } else if (_selectedOrders ==
                                  TodoOrders.statusAsc) {
                                _selectedOrders = TodoOrders.normalAsc;
                              }
                              // Desc
                              if (_selectedOrders == TodoOrders.normalDesc) {
                                _selectedOrders = TodoOrders.dateDesc;
                              } else if (_selectedOrders ==
                                  TodoOrders.dateDesc) {
                                _selectedOrders = TodoOrders.statusDesc;
                              } else if (_selectedOrders ==
                                  TodoOrders.statusDesc) {
                                _selectedOrders = TodoOrders.normalDesc;
                              }
                              setState(() {
                                debugPrint(_selectedFilters.toString());
                              });
                            },
                          ),
                          ListTile(
                            title: Text('Filtro'),
                            subtitle: Text(
                              _selectedFilters.displayTitle,
                              style: TextStyle(fontSize: 11),
                            ),
                            trailing: null,
                            onTap: () {
                              if (_selectedFilters == TodoFilters.filterAll)
                                _selectedFilters = TodoFilters.filterUnfinished;
                              else if (_selectedFilters ==
                                  TodoFilters.filterUnfinished)
                                _selectedFilters = TodoFilters.filterFinished;
                              else if (_selectedFilters ==
                                  TodoFilters.filterFinished)
                                _selectedFilters = TodoFilters.filterAll;
                              setState(() {
                                debugPrint(_selectedFilters.toString());
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.2,
                    ),
                    MaterialButton(
                        minWidth: 200,
                        color: Theme.of(context).colorScheme.secondary,
                        textColor: Theme.of(context).colorScheme.onSecondary,
                        onPressed: () {
                          TodoOptionsModel optionsModel = TodoOptionsModel(
                              filter: _selectedFilters,
                              group: _selectedGroups,
                              order: _selectedOrders);
                          widget.optionsBloc.add(optionsModel);
                          Navigator.pop(context, optionsModel);
                        },
                        child: const Text(
                          'Aplicar',
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
