import 'package:flutter/material.dart';

class WidgetShowHtml extends StatelessWidget {
  String content;

  WidgetShowHtml({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(content));
  }
}
