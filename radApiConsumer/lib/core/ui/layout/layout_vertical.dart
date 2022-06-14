import 'package:flutter/material.dart';

import '../../../modules/menu/presenter/menu.dart';

class LayoutVertical extends StatelessWidget {
  Widget child;

  LayoutVertical({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
