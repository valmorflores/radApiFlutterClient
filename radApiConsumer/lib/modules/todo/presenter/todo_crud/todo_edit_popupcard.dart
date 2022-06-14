import '/modules/todo/infra/models/todo_model.dart';
import 'package:flutter/material.dart';

import '../../../../utils/dialog/hero_dialog_route.dart';
import '../../infra/constants/constants.dart';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroTodoEdit].
/// {@endtemplate}
class TodoEditPopupCard extends StatefulWidget {
  TodoModel todoModel;

  /// {@macro add_todo_popup_card}
  TodoEditPopupCard({
    Key? key,
    required this.todoModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TodoEditPopupCardState();
}

class TodoEditPopupCardState extends State<TodoEditPopupCard> {
  late TextEditingController _textDescription;

  @override
  void initState() {
    _textDescription = TextEditingController();
    _textDescription.text = '${widget.todoModel.description}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: kheroTodoEdit + widget.todoModel.todoid.toString(),
          child: Material(
            color: Theme.of(context).colorScheme.background,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            child: Container(
              height: 300,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 200,
                        child: TextField(
                          controller: _textDescription,
                          expands: true,
                          maxLines: null,
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
                            Navigator.pop(context, _textDescription.text);
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
      ),
    );
  }
}
