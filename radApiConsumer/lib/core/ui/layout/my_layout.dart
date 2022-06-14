import '../../../core/ui/layout/layout_vertical.dart';
import '../../../core/ui/layout/layout_widescreen.dart';
import 'package:flutter/material.dart';

import 'layout_tablet.dart';

class MyLayout extends StatelessWidget {
  Widget child;
  MyLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 1024) {
      return LayoutWidescreen(child: child);
    } else if (MediaQuery.of(context).size.width <= 500) {
      return LayoutVertical(child: child);
    } else {
      return LayoutTablet(child: child);
    }
  }
}
