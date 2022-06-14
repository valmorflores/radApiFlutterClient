import 'package:flutter/material.dart';

import '/core/constants/kpresenter.dart';

class WidgetNeedRefreshError extends StatelessWidget {
  String title;
  GestureTapCallback onTap;
  BuildContext context;
  String workspace = '';

  GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  // ignore: use_key_in_widget_constructors
  WidgetNeedRefreshError({
    Key? key,
    required this.title,
    required this.onTap,
    required this.context,
    required this.workspace,
  }) {}

  @override
  Widget build(BuildContext context) {
    return render();
  }

  render() {
    return InkWell(
        onTap: onTap,
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            onTap();
          },
          child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(Icons.refresh, size: 64),
                Container(
                  width: MediaQuery.of(context).size.width -
                      (workspace != '' ? kSizeWorkspaceTitle : 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 14, 8, 0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 8, 0),
                  child: Text(
                    'Nenhuma informação retornada do servidor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 8, 0),
                  child: Text(
                    'Clique para refazer a consulta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18),
                  ),
                ),
                (workspace != '')
                    ? Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text('$workspace'),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 100,
                ),
              ])),
        ));
  }
}
