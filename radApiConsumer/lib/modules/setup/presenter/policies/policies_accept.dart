import '/core/widgets/_widget_show_html.dart';
import '/modules/setup/presenter/controllers/policies_controller.dart';
import '/utils/progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoliciesAccept extends StatelessWidget {
  PoliciesController _policiesController = Get.put(PoliciesController());

  PoliciesAccept({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Política de privacidade'),
          actions: [
            InkWell(
                child: Padding(
                    padding: EdgeInsets.all(8), child: Icon(Icons.check)),
                onTap: () {
                  _policiesController.setToAccepted();
                  Navigator.pop(context);
                }),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 120,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(() => Text(
                          'Refreshing data/count: ${_policiesController.count}',
                          style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onPrimary))),
                      FutureBuilder(
                          future: _policiesController.getPolicies(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Transform(
                                  transform:
                                      Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
                                  child: progressBar(context),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                    Text('Error: {$snapshot.error}'),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasData) {
                              String _content = (snapshot.data as String);
                              return Column(children: [
                                SizedBox(
                                  height: 50,
                                ),
                                WidgetShowHtml(content: _content),
                                SizedBox(
                                  height: 20,
                                ),
                              ]);
                            }
                            return Container();
                          }),
                    ],
                  ),
                ),
              ),
              Container(
                  height: 50,
                  child: Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              _policiesController.setToAccepted();
                              Navigator.pop(context);
                            },
                            child: Text('Li e aceito os termos',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground))),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
