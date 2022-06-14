import 'package:dartz/dartz.dart';
import '/core/enums/enum_modules.dart';
import '/core/widgets/_widget_dialog_notificiation_message.dart';
import '/modules/setup/presenter/controllers/policies_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoliciesNotification extends StatelessWidget {
  final PoliciesController _policiesController = Get.put(PoliciesController());

  PoliciesNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      const Spacer(),
      InkWell(
        child: Container(
          height: MediaQuery.of(context).size.height * .70,
          child: Align(
              child: Text('Clique para iniciar'), alignment: Alignment.center),
        ),
        onTap: () async {
          if (await _policiesController.getPoliciesState() ==
              PoliciesState.isAccepted) {
            Navigator.pop(context);
          }
          _doShowPoliciesAcception(context);
          if (await _policiesController.getPoliciesState() ==
              PoliciesState.isAccepted) {
            Navigator.pop(context);
          }
        },
      ),
      const Spacer(),
    ]));
  }

  _doShowPoliciesAcception(context) async {
    return await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return WidgetDialogNotificationMessage(
            itemId: 0,
            title: 'Primeiro acesso',
            message:
                'Esta é uma instalação nova. É importante ler e aceitar a nossa política de privacidade',
            module: EIModulesLoad.modulePoliciesAccept,
          );
        });
  }
}
