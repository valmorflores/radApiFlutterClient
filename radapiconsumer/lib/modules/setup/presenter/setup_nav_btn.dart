import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SetupNavBtn extends StatelessWidget {
  String text;
  VoidCallback onPressed;

  SetupNavBtn({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
            onPressed: onPressed,
            color: Colors.pink,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            )));
  }
}
