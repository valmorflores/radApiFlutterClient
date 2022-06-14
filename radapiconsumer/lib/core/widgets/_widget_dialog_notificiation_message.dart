import '/modules/setup/presenter/policies/policies_accept.dart';
import 'package:flutter/material.dart';

import '/core/enums/enum_modules.dart';
import 'package:get/get.dart';

class WidgetDialogNotificationMessage extends StatefulWidget {
  String title;
  String message;
  int itemId;
  EIModulesLoad module;

  WidgetDialogNotificationMessage({
    Key? key,
    required this.title,
    required this.message,
    required this.itemId,
    required this.module,
  }) : super(key: key);

  @override
  _WidgetDialogNotificationMessageState createState() =>
      _WidgetDialogNotificationMessageState();
}

class _WidgetDialogNotificationMessageState
    extends State<WidgetDialogNotificationMessage> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
              child: Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white.withAlpha(50),
                  ))),
        ),
        const Spacer(),
        Container(
            width: 200,
            child: Image.asset('assets/images/dialog/new_message_pict.png')),
        Text(widget.title, style: const TextStyle(fontSize: 26)),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(widget.message),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (widget.module == EIModulesLoad.moduleActivityView) {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Container())
                      //ActivitiesView(id: widget.itemId, cached: false)),
                      );
                }

                if (widget.module == EIModulesLoad.modulePoliciesAccept) {
                  (await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PoliciesAccept()),
                  ));
                  Get.forceAppUpdate();
                }
              },
              child: const Text('IR'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('FECHAR'),
            ),
            const Spacer(),
          ],
        ),
        const Spacer(),
      ],
    ));
  }
}
