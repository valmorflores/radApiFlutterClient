import '/core/widgets/_widget_dialog_confirm_remove.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/settings_local_data_controller.dart';

class SettingsLocalData extends StatelessWidget {
  final TextEditingController _searchTextController = TextEditingController();
  SettingsLocalDataController settingsLocalDataController =
      Get.put(SettingsLocalDataController());
  //SettingsLocalDataController();
  //Get.find();
  //SettingsLocalDataController();

  SettingsLocalData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    settingsLocalDataController.buildSharedList();
    return Scaffold(
        appBar: AppBar(
          title: Text('Dados locais'),
          actions: [
            InkWell(
                child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: GestureDetector(
                        child: Icon(Icons.done_all),
                        onTap: () {
                          settingsLocalDataController.selectAll();
                        }))),
            Obx(() => (settingsLocalDataController.dataSelectedList.length > 0)
                ? InkWell(
                    child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                            child: Icon(Icons.undo_outlined),
                            onTap: () {
                              settingsLocalDataController.unselectAll();
                            })))
                : SizedBox.shrink()),
          ],
        ),
        body: Column(
          children: [
            Container(
                height: 60.0,
                padding: EdgeInsets.only(left: 20, top: 8),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20.0,
                      offset: Offset(0, 10.0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                      onChanged: _changeFilter(),
                      controller: _searchTextController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Filtro',
                      ),
                    )),
                    InkWell(
                        onTap: () {
                          _changeFilter();
                        },
                        child: Icon(Icons.search)),
                  ],
                )),
            Flexible(
              flex: 1,
              child: GetX<SettingsLocalDataController>(builder: (ix) {
                debugPrint('${ix.dataSharedList.length.toString()}');
                return Obx(() => ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: ix.dataSharedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (ix.dataSharedList[index] == null) {
                        return Container();
                      } else {
                        return ListTile(
                          selected: ix.dataSharedList[index].isSelected,
                          title: Text(ix.dataSharedList[index].key),
                          leading: ix.dataSharedList[index].isSelected
                              ? const Icon(Icons.check_circle)
                              : const Icon(Icons.circle_outlined),
                          subtitle: Text(ix.dataSharedList[index].content,
                              style: TextStyle(fontSize: 12)),
                          onTap: () {},
                          onLongPress: () {
                            if (settingsLocalDataController
                                .isSelectedKey(ix.dataSharedList[index].key)) {
                              settingsLocalDataController
                                  .unselectKey(ix.dataSharedList[index].key);
                            } else {
                              settingsLocalDataController
                                  .selectKey(ix.dataSharedList[index].key);
                            }
                          },
                        );
                      }
                    }));
              }),
            ),
            Obx(() => ((settingsLocalDataController.dataSelectedList.length > 0)
                ? Container(
                    height: 70.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          InkWell(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                      child: Icon(Icons.delete),
                                      onTap: () {
                                        _removeBtnDo(context);
                                      }))),
                          const Spacer(),
                          (settingsLocalDataController
                                      .dataSelectedList.length ==
                                  1)
                              ? InkWell(
                                  child: Icon(Icons.copy),
                                  onTap: () {
                                    settingsLocalDataController
                                        .copySelectedToClipboard();
                                  },
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ))
                : Container()))
          ],
        ));
  }

  _removeBtnDo(context) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return WidgetDialogConfirmRemove(onTap: () async {
            //await removeArticlesController
            //    .deleteByIds(selectedArticles);
            settingsLocalDataController.removeSelected();
            Navigator.of(context).pop();
            _refresh();
          });
        });
  }

  _copy() {}

  _refresh() {
    _changeFilter();
  }

  _changeFilter() {
    debugPrint('f7457 - Apply filter ${_searchTextController.text}');
    settingsLocalDataController.applyFilter(_searchTextController.text);
  }
}
