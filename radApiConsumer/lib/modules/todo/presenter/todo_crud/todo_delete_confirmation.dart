import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodoRemoveConfirmation extends StatelessWidget {
  TodoRemoveConfirmation({Key? key}) : super(key: key);

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
                color: Colors.red,
              ),
              child: Wrap(children: [
                Container(
                  height: 20,
                ),
                const ListTile(
                  leading: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.warning_sharp, color: Colors.white),
                  ),
                  title: Text(
                    '\nConfirma a exclusão?\n',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Ao confirmar, todos os registros selecionados serão apagados',
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
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: Text(
                            'Apagar os dados',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop(true);
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
