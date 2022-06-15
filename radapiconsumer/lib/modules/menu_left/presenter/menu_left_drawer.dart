import '/core/widgets/_widget_staff_avatar.dart';

import '/modules/setup/infra/models/workspace_model.dart';
import '/modules/staff/presenter/controllers/staff_controller.dart';
import '/modules/staff/presenter/staff_profile_editor/staff_profile_editor.dart';
import '/routes.dart';
import '/utils/globals.dart';
import '/modules/menu_left/domain/classes/wokspace_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MenuLeftDrawer extends StatefulWidget {
  List selectedIndexes = [];

  @override
  _MenuLeftDrawerState createState() => _MenuLeftDrawerState();
}

class _MenuLeftDrawerState extends State<MenuLeftDrawer> {
  late WorkspaceSelector _workspaceSelector;
  Future<List<WorkspaceModel>>? _workspaces;

  StaffController _staffController = Get.put(StaffController());

  @override
  void initState() {
    _workspaceSelector = WorkspaceSelector();

    loadSetupInfo();
    loadStaffInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // loadstaff awaiting for data complete
  loadStaffInfo() async {
    if (app_user.id != null) {
      await _staffController.selectStaff(app_user.id ?? 0);
    }
  }

  loadSetupInfo() async {
    _workspaces =
        _workspaceSelector.favoriteList(); //. _favoriteWorkpacesLocalList();
    if ((await _workspaces)!.length > 0) {
      debugPrint('f6743 - ' + (await _workspaces)![0].name);
    }
    debugPrint('f6743 - done');
  }

  @override
  Widget build(BuildContext context) {
    String _url = _staffController.urlImage();
    Icon _icon = Icon(Icons.photo);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Obx(() => Stack(
                    children: [
                      Text('${_staffController.count}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background)),
                      WidgetStaffAvatar(
                        urlImage: _url,
                        shape: BoxShape.circle,
                        width: 100.0,
                        height: 100.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                  //color: Colors.black.withAlpha(40),
                                  onTap: () async {
                                    await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StaffProfileEditor(
                                              app_user.staffid ?? 0);
                                        });
                                    Navigator.pop(context);
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        //Theme.of(context).colorScheme.onBackground,
                                      )))),
                        ],
                      )
                    ],
                  ))),
          const SizedBox(height: 20),
          SizedBox(
              height: 60,
              child: Row(children: [
                Column(children: [
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Text('Workspaces'),
                    )
                  ]),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Text('Disponíveis'),
                    )
                  ]),
                ]),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 18, 8),
                  child: GestureDetector(
                      child: Icon(Icons.add_circle_outline_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withAlpha(50)),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.setup_workspace);
                      }),
                )
              ])),
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              setState(() {
                debugPrint('f0788 - Refreshing list...');
                loadSetupInfo();
                debugPrint('f0788 - do!');
              });
            },
            child: FutureBuilder(
                future: _workspaces,
                builder: (context, snapshot) {
                  debugPrint('f0788 - future for workspaces...');

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.done:
                    default:
                  }

                  if (snapshot.hasData) {
                    debugPrint('f0788 - builder with data...');
                    List<WorkspaceModel> dataList =
                        snapshot.data as List<WorkspaceModel>;
                    debugPrint(
                        'f0788 - size of records: ${dataList.length.toString()}');
                    return Container(
                      height: MediaQuery.of(context).size.height -
                          300, //<------ todo: valmor: fix here
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          itemCount: dataList.length,
                          itemBuilder: (_, id) {
                            debugPrint(
                                'f0788 - item [' + id.toString() + ']...');
                            final item = dataList[id];
                            bool _isSelected = false;
                            if (app_selected_workspace_name != '' &&
                                ('@' + item.name)
                                    .contains(app_selected_workspace_name)) {
                              _isSelected = true;
                            }
                            Widget _iconTrailing = Container();
                            if (item.gameMode == 1) {
                              _iconTrailing = Icon(Icons.sports_esports);
                            } else {
                              _iconTrailing = SizedBox(width: 32);
                            }
                            return ListTile(
                              selected: _isSelected,
                              trailing: _iconTrailing,
                              title: Text(
                                '${item.name}',
                              ),
                              subtitle: Text(item.domain == 'personal'
                                  ? 'Pessoal'
                                  : 'Institucional'),
                              onLongPress: () {},
                              onTap: () {
                                // Update the state of the app.
                                // ...
                                //
                                setState(() {
                                  _workspaceSelector.select(item.name);
                                  debugPrint(
                                      'Apply forceAppUpdate via Get to refresh all windows...');
                                  Get.forceAppUpdate();
                                  Navigator.pop(context);
                                });
                              },
                            );
                          }),
                    );
                  }
                  debugPrint('f0788 - done...');
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}
