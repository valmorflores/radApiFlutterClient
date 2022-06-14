import '/modules/settings/infra/models/shared_data_list.dart';
import '/modules/settings/presenter/settings_local_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

const sizeContent = 512;

class SettingsLocalDataController extends GetxController {
  final RxList dataSharedList = <SharedDataList>[].obs;
  final RxList dataSelectedList = <String>[].obs;
  final RxString _filter = ''.obs;

  void buildSharedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int i = 0;
    List<String> _keys = [];
    _keys.addAll(prefs.getKeys());
    // Filter aply
    if (_filter.value.isNotEmpty) {
      _keys =
          _keys.where((element) => element.contains(_filter.value)).toList();
    }
    debugPrint('f7804 - keys-size: ${_keys.length}');
    // continue getting content
    _keys.forEach((element) async {
      //++i;
      //debugPrint('f7804 - ${i.toString()} : ${element}');
      String _content = '';
      try {
        _content = await prefs.getString(element) ?? '';
      } catch (e) {
        _content = '[Erro loading content => ${e.toString()}]';
      }
      if (_content.length > sizeContent) {
        _content = _content.substring(0, sizeContent);
      }

      SharedDataList _data = SharedDataList(
          key: element,
          content: _content,
          isActive: true,
          isSelected: false,
          isDeleted: false);
      dataSharedList.add(_data);
    });
  }

  void selectKey(String selKey) {
    dataSelectedList.add(selKey);
    for (var element in dataSharedList) {
      if (element.key == selKey) {
        element.isSelected = true;
      }
    }
    update();
  }

  void unselectKey(String selKey) {
    dataSelectedList.remove(selKey);
    for (var element in dataSharedList) {
      if (element.key == selKey) {
        element.isSelected = false;
        debugPrint('f7825 - Unselect key: $selKey');
      }
    }
    update();
  }

  bool isSelectedKey(String selkey) {
    if (dataSelectedList.isNotEmpty) {
      if (dataSelectedList[0] == selkey) return true;
    }
    return dataSelectedList.indexOf(selkey, 1) > 0;
  }

  void removeKey(String strKeyName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(strKeyName);
  }

  void removeSelected() {
    dataSelectedList.forEach((element) {
      removeKey(element);
    });
  }

  // clear and apply filter
  void applyFilter(String filter) {
    dataSharedList.clear();
    dataSelectedList.clear();
    _filter.value = filter;
    buildSharedList();
    update();
  }

  void selectAll() {
    dataSelectedList.clear();
    dataSharedList.forEach((element) {
      element.isSelected = true;
      dataSelectedList.add(element.key);
    });
    update();
  }

  void unselectAll() {
    dataSelectedList.clear();
    dataSharedList.forEach((element) {
      element.isSelected = false;
    });
    update();
  }

  void copySelectedToClipboard() async {
    String _key = '';
    if (dataSelectedList.isNotEmpty) {
      // Primeiro elemento
      _key = dataSelectedList[0];
    }
    if (_key.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String info = prefs.getString(_key) ?? '';
      await Clipboard.setData(ClipboardData(text: '$info'));
      Get.snackbar(_key, 'Dados copiados para área de transferência',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    buildSharedList();
    _filter.value = '';
  }
}
