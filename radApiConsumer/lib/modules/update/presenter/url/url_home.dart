import '/modules/update/presenter/controllers/url_controller.dart';
import '/modules/update/infra/models/url_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UrlHome extends StatelessWidget {
  UrlController urlController = Get.put(UrlController());

  UrlHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    urlController.loadUrls();
    final UrlModel? url = urlController.getUrls();
    if (url != null) {
      debugPrint('f7078 - Urls carregadas com sucesso');
    } else {
      debugPrint('f7078 - Urls ainda sem dados');
    }
    return Scaffold(
        appBar: AppBar(
            title: Obx(() => Text(
                'Informações técnicas carregadas: ${urlController.count.toString()}'))),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check_circle),
          onPressed: () {
            final UrlModel? url = urlController.getUrls();
            if (url != null) {
              debugPrint('f7078 - Urls carregadas com sucesso');
            } else {
              debugPrint('f7078 - Urls ainda sem dados');
            }
          },
        ),
        body: Container());
  }
}
