import 'package:flutter/material.dart';

import '../../../modules/menu/presenter/menu.dart';

class LayoutTablet extends StatelessWidget {
  Widget child;

  LayoutTablet({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: 220,
          child: Menu(),
        ),
        Flexible(child: child)
      ],
    ));
  }
}
