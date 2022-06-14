import '/global/repositories/login_repository.dart';
import '/global/resources/kconstants.dart';
import '/modules/setup/infra/models/workspace_model.dart';
import '/modules/setup/setup_load.dart';
import '/modules/staff/presenter/controllers/staff_controller.dart';
import '/modules/update/presenter/controllers/url_controller.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkspaceSelector {
  late Future<List<WorkspaceModel>> _workspaces;
  late LoginRepository _loginRepository;
  UrlController urlController = Get.put(UrlController());
  final StaffController _staffController = Get.put(StaffController());

  // Construct
  WorkspaceSelector({Key? key}) {
    _loginRepository = LoginRepository();
    _load();
  }

  // External methods
  select(String name) {
    debugPrint('f6328 - Selector method start with param: name => ' + name);
    if (name.contains('@')) {
      name = name.substring(1);
    }
    debugPrint('f6328 - After convertion of params: name => ' + name);
    return _runWorkspace(name);
  }

  Future<List<WorkspaceModel>> favoriteList() async {
    return _favoriteWorkpacesLocalList();
  }

  // Internal methods
  _load() async {
    _workspaces = _favoriteWorkpacesLocalList();
    debugPrint('f5543 - Size of workspaces = ' +
        (await _workspaces).length.toString());
    if ((await _workspaces).length > 0) {
      debugPrint('f5543 - ' + (await _workspaces)[0].name);
    }
    debugPrint('f5543 - done');
  }

  _runWorkspace(String name) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    debugPrint('f6328 - Running with workspace name => ' + name);
    (await _workspaces).forEach((element) async {
      if (element.name == name) {
        if (element.domain == 'personal') {
          // if PERSONAL need app_workspace_name (workspace into header)
          app_workspace_name = name;
          app_selected_workspace_name = '@' + name;
          app_urlapi =
              'https://criativa.app/work/servers/sei1/gestorequipes/api/v1';
          app_userkey = element.workspaceKeyValue;
        } else {
          // if company no need app_workspace_name (workspace into header)
          app_workspace_name = '';
          app_selected_workspace_name = name;
          app_urlapi =
              'https://criativa.app/work/servers/sei1/gestorequipes/api/v1';
          if (name == "cosems.rs") {
            app_urlapi = 'https://cosems.com/gestorequipes/api/v1';
          }
          if (name == "ws") {
            app_urlapi = 'https://criativa.app/work/servers/sei2021ws/api/v1';
          }
        }
        // Set game mode
        if (element.gameMode == 1) {
          app_game_mode = 1;
        } else {
          app_game_mode = 0;
        }
        // Save myuserkey
        app_userkey = element.workspaceKeyValue;
        await prefs.setString('myuserkey', app_userkey);
        // Save selected workspace
        await prefs.setString('myworkspace', app_selected_workspace_name);
        await prefs.setString('mypersonal_workspace_name', app_workspace_name);
        debugPrint('f6328 - Save selected workspace [' +
            app_selected_workspace_name +
            '] personal =>' +
            app_workspace_name);
        // Login with key
        debugPrint('f6328 - LoginRepository->login() ' + app_userkey);
        await _loginRepository.login();
        await urlController.loadUrls();
        await _staffController.loadStaffList();
        await _staffController.selectStaff(app_user.staffid ?? 0);
      }
    });
  }

  Future<List<WorkspaceModel>> _favoriteWorkpacesLocalList() async {
    SetupLoad setup = SetupLoad();
    String userkey;
    String name;
    String domainInfo;
    List<WorkspaceModel> workspaces = [];
    //List domains = [];
    List<MyDomainList> domains = await _workspacesDomainsList();

    // List of first workspaces
    for (var i = 0; i < 100; i++) {
      name = await setup.loadWksParam(kWorkspaceCfgList, i.toString());
      var _game_mode =
          await setup.loadWksParam(kWorkspaceCfgListGameMode, i.toString());
      int _gameMode = 0;
      if (_game_mode.contains('1')) {
        _gameMode = 1;
      }

      if (name == null) {
        name = '';
      } else if (name != '') {
        domainInfo = '';
        debugPrint('f0924 - getting informations domains...');
        try {
          var domain = domains.firstWhere((i) => i.name == name);
          domainInfo = domain.domain;
        } catch (e) {
          debugPrint('f0924 - error:' + e.toString());
        }
        debugPrint('f0924 - domain[' + name + '] => ' + domainInfo);
        userkey = await setup.loadWksParam(name, 'userkey');
        debugPrint('f0924 - domain[' + name + '] userkey => ' + userkey);
        workspaces.add(new WorkspaceModel(
            index: i,
            name: name,
            workspaceKeyValue: userkey,
            domain: domainInfo,
            gameMode: _gameMode));
      }
    }
    return workspaces;
  }

  // Domains can be a unordered list (consider max of 100 workspaces)
  _workspacesDomainsList() async {
    SetupLoad setup = SetupLoad();
    List<MyDomainList> domains = [];
    String name;
    String domain;
    for (var i = 0; i < 100; i++) {
      String itemNameWithDomain =
          await setup.loadWksParam(kWorkspaceCfgListDomains, i.toString());
      if (itemNameWithDomain != '') {
        name = itemNameWithDomain.split('/')[0];
        domain = itemNameWithDomain.split('/')[1];
        domains.add(MyDomainList(name: name, domain: domain));
      }
    }
    return domains;
  }
}

class MyDomainList {
  String name;
  String domain;

  MyDomainList({required this.name, required this.domain});
}
