import 'package:flutter/material.dart';

Widget progressBar(context) {
  int degrees = 180;
  double size = (MediaQuery.of(context).size.width - 4) / 2;
  var pi = 3.1415927;
  final radians = degrees * pi / 180;

  return Wrap(children: <Widget>[
    Container(
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
      ),
      height: 1,
      child: LinearProgressIndicator(
        color: Theme.of(context).colorScheme.primaryVariant,
      ),
    ),
    Container(
        height: 1,
        child: Transform.rotate(
            angle: radians,
            child: LinearProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ))),
  ]);
/*
  return Container(
      height: 2,
      width: double.infinity,
      child: Row(children: [
        SizedBox(
            width: size,
            child: Transform.rotate(
                angle: radians, child: LinearProgressIndicator())),
        SizedBox(child: LinearProgressIndicator(), width: size),
      ]));
      */
}
