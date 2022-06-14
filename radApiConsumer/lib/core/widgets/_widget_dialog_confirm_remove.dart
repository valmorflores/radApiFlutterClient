import 'package:flutter/material.dart';

class WidgetDialogConfirmRemove extends StatelessWidget {
  GestureTapCallback onTap;

  WidgetDialogConfirmRemove({
    Key? key,
    required this.onTap,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
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
              '\nVocê confirma a exclusão?\n',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Ao confirmar, todos os dados marcados serão excluídos do sistema. Você confirma a exclusão?',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            child: Row(children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: GestureDetector(
                    onTap: onTap,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: onTap)),
              ),
            ]),
          ),
          Container(
            height: 20,
          ),
        ]));
  }
}
