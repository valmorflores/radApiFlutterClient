import '/core/constants/kmessages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetCriticalUnsavedError extends StatelessWidget {
  const WidgetCriticalUnsavedError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    render();
    return Container();
  }

  render() {
    Get.defaultDialog(
        actions: [
          MaterialButton(
            child: const Text('OK'),
            onPressed: () => Get.back(),
          )
        ],
        backgroundColor: Colors.red,
        title: kMessageCriticalUnsaveTitle,
        content: const Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(kMessageCriticalUnsave),
        ));
  }
}
