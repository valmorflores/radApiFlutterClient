import 'package:flutter/material.dart';

import '../../core/constants/kpresenter.dart';
import '../../utils/globals.dart';

class WidgetPageTitle extends StatelessWidget {
  String title;
  GestureTapCallback onTap;
  BuildContext context;
  String? workspace;
  bool? showWorkspace;

  WidgetPageTitle({
    Key? key,
    required this.title,
    this.workspace,
    required this.onTap,
    required this.context,
    this.showWorkspace,
  }) {
    workspace ??= '';
    showWorkspace ??= true;
    if (showWorkspace! && (workspace == '')) {
      if (app_selected_workspace_name != null) {
        workspace = app_selected_workspace_name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return render();
  }

  render() {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Row(children: [
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width -
                    (workspace != '' ? kSizeWorkspaceTitle : 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  //border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 8, 4),
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            (workspace != '')
                ? Container(
                    width: (kSizeWorkspaceTitle > 0) ? kSizeWorkspaceTitle : 0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      //border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 8, 4),
                      child: Visibility(
                          visible: showWorkspace!, child: Text('$workspace')),
                    ),
                  )
                : Container(),
          ])),
    );
  }
}
