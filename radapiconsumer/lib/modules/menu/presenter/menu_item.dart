import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '/modules/element/infra/models/element_model.dart';

import 'menu_bloc.dart';

class MenuOption extends StatelessWidget {
  final ElementModel item;
  final Animation? animation;
  final VoidCallback? onClick;
  final VoidCallback? onRemoveClick;
  final VoidCallback? onLongPress;
  List? removedIndexes = [];
  List? selectedIndexes = [];
  MenuBloc bloc;

  MenuOption({
    Key? key,
    required this.item,
    this.animation,
    this.onClick,
    this.onRemoveClick,
    this.onLongPress,
    required this.bloc,
    this.removedIndexes,
    this.selectedIndexes,
  }) : super(key: key) {
    if (removedIndexes == null) {
      removedIndexes = [];
    }
    if (selectedIndexes == null) {
      selectedIndexes = [];
    }
  }

  selectItem(int id) {
    if (selectedIndexes!.indexOf(id, 1) <= 0) {
      selectedIndexes!.add(id);
    } else {
      selectedIndexes!.remove(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: item.visible! && !removedIndexes!.contains(item.index),
        child: Card(
            /*color: (!selectedIndexes.contains(item.index))
                ? Theme.of(context).cardColor
                : Theme.of(context).accentColor,*/
            child: ListTile(
          /// selectedTileColor: Colors.amber,
          selected: item.selected!,
          title: Text(
            '${item.name!}',
            /*style: TextStyle(
                    color: selectedIndexes
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).canvasColor),*/
          ),
          //trailing: Icon(Icons.check),
          trailing: (item.checked != null)
              ? item.checked!
                  ? Icon(Icons.check)
                  : Text('')
              : Text(''),
          subtitle: Text(
            '${item.subtitle}',
            /*style: TextStyle(
                      color: selectedIndexes.contains(item.index)
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).colorScheme.onSecondary)*/
          ),
          onLongPress: onLongPress,
          onTap: onClick,
        )));
  }
}
