import '/global/resources/kconstants.dart';
import '/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infra/models/device_model.dart';
import 'infra/models/setup_install_vars.dart';

class SetupLoad {
  loadAppState() async {
    var prefs = await SharedPreferences.getInstance();
    String workspace = prefs.getString('myworkspace') ?? '';
    String workspacePersonal =
        prefs.getString('mypersonal_workspace_name') ?? '';
    String deviceAlias = prefs.getString('app_device_alias') ?? '';
    String deviceEmail = prefs.getString('app_device_email') ?? '';
    // Se workspace isNull all data is empty
    if (workspace == '') {
      app_selected_workspace_name = '';
      workspacePersonal = '';
    } else {
      app_selected_workspace_name = workspace.isNotEmpty ? workspace : '';
      if (workspacePersonal == '') {
        workspacePersonal = '';
      }
      app_workspace_name =
          workspacePersonal.isNotEmpty ? workspacePersonal : '';
    }
    if (setup_app_device == null) {
      setup_app_device =
          new DeviceModel(alias: deviceAlias, email: deviceEmail);
    } else {
      if (setup_app_device!.alias == '') {
        setup_app_device!.alias = deviceAlias;
        setup_app_device!.email = deviceEmail;
      }
    }
  }

  saveAppState() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_device_alias', setup_app_device!.alias);
    await prefs.setString('app_device_email', setup_app_device!.email);
  }

  clearAppState() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_device_email');
    await prefs.remove('app_device_alias');
    return true;
  }

  Future<String> loadWksParam(String workspaceName, String param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String parameter = kWorkspaceCfgPre + '/' + workspaceName + '/' + param;
    String info = prefs.getString(parameter) ?? '';
    return info;
  }

  saveWksParam(String workspaceName, String param, String info) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        kWorkspaceCfgPre + '/' + workspaceName + '/' + param, info);
  }

  saveHelpStatus(String param, String info) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(kHelpCfgPre + '/' + param, info);
  }

  Future<String> loadHelpStatus(String param) async {
    var prefs = await SharedPreferences.getInstance();
    String info = prefs.getString(kHelpCfgPre + '/' + param) ?? '';
    return info.toString();
  }
}
