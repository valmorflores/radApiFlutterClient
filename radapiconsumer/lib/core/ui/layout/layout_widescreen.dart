import 'package:flutter/material.dart';

import '../../../modules/menu/presenter/menu.dart';

class LayoutWidescreen extends StatelessWidget {
  Widget child;

  LayoutWidescreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Column(
          children: [
            Container(
                width: 365,
                color: Colors.black12,
                height: 90,
                child: Column(children: [
                  const Spacer(),
                  Text('Equipe Integrada'),
                  const Spacer(),
                ])),
            Flexible(
              child: Container(
                width: 365,
                child: Menu(),
              ),
            ),
          ],
        ),
        Flexible(child: child)
      ],
    ));
  }
}
