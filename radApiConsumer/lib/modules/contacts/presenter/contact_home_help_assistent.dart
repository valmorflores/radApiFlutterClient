import '/global/resources/kconstants.dart';
import '/modules/setup/setup_load.dart';
import 'package:flutter/material.dart';

class ContactHomeHelpAssistent extends StatefulWidget {
  @override
  _ContactHomeHelpAssistentState createState() =>
      _ContactHomeHelpAssistentState();
}

class _ContactHomeHelpAssistentState extends State<ContactHomeHelpAssistent> {
  late Future<bool> lOk;
  SetupLoad setup = SetupLoad();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatusHelp();
  }

  getStatusHelp() async {
    lOk = setup.loadHelpStatus(kHelpContact).then((value) => (value == '1'));
    debugPrint('f5633 - Help information status: ' +
        kHelpContact +
        ' => ' +
        (await lOk).toString());
  }

  setStatusHelpOk() async {
    await setup.saveHelpStatus(kHelpContact, '1');
    getStatusHelp();
    debugPrint('f5633 - Help information status/saved: ' +
        kHelpContact +
        ' => ' +
        '1');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: lOk,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return Container();
            } else {
              return Container(
                color: Theme.of(context).colorScheme.secondary, //.pink[700]
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(children: [
                    ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                              height: 32,
                              width: 32,
                              color: Theme.of(context).colorScheme.onSecondary,
                              image: AssetImage(
                                  'assets/internal_icons/help_finger_left.png')),
                        ),
                        title: Text(
                          'Esquerda ou direita',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        subtitle: Text(
                          'Você pode deslizar a tela para a esquerda ou direita para acessar mais informações e recursos.',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        )),
                    //
                    Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              setStatusHelpOk();
                            });
                          },
                          child: Text(
                            "Entendi",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            }
          }
          return Container();
        });
  }
}
