import 'package:flutter/material.dart';

class ClientDetailHelpAssistent extends StatefulWidget {
  @override
  _ClientDetailHelpAssistentState createState() =>
      _ClientDetailHelpAssistentState();
}

class _ClientDetailHelpAssistentState extends State<ClientDetailHelpAssistent>
    with SingleTickerProviderStateMixin {
  bool lOk = false;

  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = Tween(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return lOk
        ? Container()
        : AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: (lOk == false) ? 1.0 : 0.0,
            duration: Duration(milliseconds: 900),
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              height: 170,
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
                        'Deslize para esquerda',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      subtitle: Text(
                        'Para acessar aos contatos desta instituição, deslize para a esquerda',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      )),
                  //
                  Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            lOk = true;
                          });
                        },
                        child: const Text(
                          "Entendi",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              /**/
            ),
          );
  }
}
