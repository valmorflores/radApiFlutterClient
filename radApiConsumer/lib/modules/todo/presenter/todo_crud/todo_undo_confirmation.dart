import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodoUndoConfirmation extends StatelessWidget {
  TodoUndoConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return confirm(context);
  }

  confirm(context) {
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.black26,
              ),
              child: Wrap(children: [
                Container(
                  height: 20,
                ),
                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.warning_sharp, color: Colors.white),
                  ),
                  title: Text(
                    '\nDeseja desmarcar a finalização?\n',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Ao confirmar, todos os registros de conclusão, inclusive as datas serão limpos',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: Row(children: [
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.primary),
                          child: Text(
                            'Marcar como não feito',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                            return;
                          }),
                    ),
                  ]),
                ),
                Container(
                  height: 20,
                ),
              ]));
        });
  }
}
