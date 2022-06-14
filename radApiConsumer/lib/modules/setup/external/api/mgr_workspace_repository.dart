import 'dart:convert';

import '../../../../modules/setup/infra/models/device_model.dart';
import '../../../../modules/setup/infra/models/workspace_model.dart';
import '../../../../modules/staff/infra/models/staff_key_model.dart';
import '../../../../modules/workspaces/infra/models/person_model.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/mgr_custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*


{
  "data": [
    {
      "id": 6,
      "name": "valmor1",
      "path": null,
      "fullpath": null,
      "dataserver": null,
      "datadomain": null,
      "server": null
    }
  ],
  "device": {
    "alias": "2021~valmorflores@gmail.com91293bfa13663513fa0b596583991f50",
    "status": "Unauthorized"
  },
  "code": 200
}

---------------------
{
  "message": "Workspace name exists"
}

---------------------
{
  "device": {
    "alias": "2021~valmorflores@gmail.com91293bfa13663513fa0b596583991f50",
    "status": "Unauthorized"
  },
  "message": "Device unauthorized. solve this to create a workspace",
  "code": 401
}

*/

class MgrWorkspaceRepository {
  // To do request install for actual device
  Future<WorkspaceModel> create(
      String workspaceName, String deviceAlias) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/workspaces/create";
    var dataInstall = {
      'workspace': workspaceName,
      'device_id': deviceAlias,
      'id': 0
    };
    debugPrint('Url: ' + url);
    debugPrint('Device alias: ' + deviceAlias);
    WorkspaceModel result = (new WorkspaceModel());
    try {
      result = await dio.post(url, data: dataInstall).then((res) async {
        debugPrint(res.toString());
        var dados = res.data['data'];
        debugPrint('-json-');
        debugPrint(dados);
        WorkspaceModel workspaceModel = WorkspaceModel();
        if (res.statusCode == 200 || int.parse(dados['code']) == 200) {
          workspaceModel.id = dados['id'];
          workspaceModel.name = dados['name'];
          workspaceModel.domain = dados['domain'];
          workspaceModel.path = dados['path'];
          workspaceModel.fullpath = dados['fullpath'];
          return workspaceModel;
        } else if (int.parse(dados['code']) != 200) {
          return (new WorkspaceModel());
        }
        return (new WorkspaceModel());
      });
    } catch (e) {
      result = (new WorkspaceModel());
    }
    return result;
  }

  Future<PersonModel> getMyPerson(DeviceModel device) async {
    debugPrint(
        'Getting person form server, for device alias = ' + device.alias);
    PersonModel person;
    person = await this.getPersonByDevice(device);
    if (person.id! <= 0) {
      person = await this.createPerson(device);
      debugPrint('Ok, returning personal');
    }
    return person;
  }

  Future<PersonModel> getPersonByDevice(DeviceModel device) async {
    debugPrint('f0902 - Person from ' + device.alias);
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/device/person";
    debugPrint('f0902 - Device person get-----------------');
    debugPrint(device.alias.toString());
    debugPrint('f0902 - Url:' + url);
    debugPrint('f0902 - Device person get:end-----------------');
    var params = {'device_id': device.alias, 'id': 0};
    return dio.post(url, data: params).then((res) async {
      debugPrint(res.toString());
      int index = 0, i = 0;
      //if (int.parse(res.data['code']) == 200) {
      debugPrint(res.data['data']);
      var dados = res.data['data'];
      debugPrint(dados.toString());
      debugPrint('f0902 - Going to forEach...');
      PersonModel result;
      if (res.data['code'] != null) {
        if (res.data['code'] > 300) {
          debugPrint('f0902 - res[data][code] Error result');
          result = PersonModel(id: 0);
          return result;
        }
      }
      debugPrint('f0902 - ' + res.data['code'].toString());
      if (dados['id'] == null) {
        result = PersonModel(id: 0);
      } else {
        result = PersonModel(id: dados['id'], name: dados['name']);
      }
      debugPrint('f0902 - Person received with success, returning----');
      return result;
    });
  }

  Future<PersonModel> createPerson(DeviceModel device) async {
    debugPrint(
        'f0408 - Creating a new person into server, for device alias = ' +
            device.alias);
    var dio = MgrCustomDio().instance;
    var url = mgr_urlapi + "/device/person/create";
    debugPrint('f0408 - device person get-----------------');
    debugPrint(device.alias.toString());
    debugPrint('f0408 - Url:' + url);
    debugPrint('f0408 - Device person get:end-----------------');
    var params = {'device_id': device.alias.toString(), 'id': 0};
    return dio.post(url, data: params).then((res) async {
      debugPrint(res.toString());
      int index = 0, i = 0;
      //if (int.parse(res.data['code']) == 200) {
      debugPrint(res.data['data']);
      var dados = res.data['data'];
      debugPrint(dados.toString());
      debugPrint('Going to forEach...');
      PersonModel result = PersonModel(id: dados['id'], name: dados['name']);
      debugPrint('-> Person received with success, returning----');
      return result;
    });
  }

  Future<List<WorkspaceModel>> getMyPersonWorkspaces(PersonModel person) async {
    if (person.id! <= 0) {
      debugPrint('f0901 - Empty person...');
      return [new WorkspaceModel()];
    }
    List<WorkspaceModel> workspaces;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/person/" + person.id.toString() + "/workspaces";
    debugPrint('f0901 - Person workspaces-----------------');
    debugPrint(
        'f0901 - Id: ' + person.id.toString() + ' - Name: ' + '${person.name}');
    debugPrint('f0901 - url: ' + url);
    debugPrint('f0901 - Person:end-----------------');
    workspaces = [];
    debugPrint('f0901 - Do API get');
    var res;
    try {
      res = await dio.get(url);
      debugPrint('f0901 - Success');
      if (res.statusCode > 300) {
        debugPrint('f0901 - Result with error: ' + res.statusCode.toString());
      }
      //debugPrint('f0901 - ' + res.toString());
      int index = 0, i = 0;
      //if (int.parse(res.data['code']) == 200) {
      //debugPrint('f0901 - ' + res.data['data'].toString());
      var dados = res.data['data'];
      debugPrint('f0901 - Going to forEach...');
      dados.forEach((item) {
        debugPrint('f0901 - Getting item number #' + i.toString());
        //debugPrint(item.toString());
        if (item['id'] != null) {
          int _game_mode = 0;
          debugPrint('f0901 - Game mode = ${item['game_mode']}');
          var game = item['game_mode'];
          debugPrint('f0901 - Game mode = $game');
          _game_mode = game;
          WorkspaceModel _workspace = WorkspaceModel(
            index: ++i,
            id: int.parse(item['id'].toString()),
            name: item['name'] ?? '',
            server: item['dataserver'] ?? '',
            domain: item['datadomain'] ?? '',
            path: item['path'] ?? '',
            fullpath: item['fullpath'] ?? '',
            workspaceKeyValue: item['workspacekeyvalue'] ?? '',
            gameMode: _game_mode,
          );
          if (!workspaces.contains(_workspace)) {
            workspaces.add(_workspace);
          }
        }
      });
      debugPrint(
          'f0901 -> Workspaces list received with success, returning----');
      return workspaces;
    } catch (e) {
      debugPrint('f0901 - Result with error, resulting workspace empty list ');
      return workspaces;
    }
  }

  Future<WorkspaceModel> getWorkspaceDetail(String name) async {
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/workspaces/" + name;
    debugPrint('workspace detail-----------------');
    debugPrint(name);
    debugPrint('url:' + url);
    debugPrint('workspace detail:end-----------------');
    WorkspaceModel workspaceDetail;
    return dio.get(url).then((res) async {
      debugPrint(res.toString());
      int index = 0, i = 0;
      //if (int.parse(res.data['code']) == 200) {
      debugPrint(res.data['data']);
      var dados = res.data['data'];
      debugPrint(dados.toString());
      debugPrint('Going to forEach...');
      workspaceDetail = WorkspaceModel(
        id: dados['id'],
        name: dados['name'],
        server: dados['server'],
        path: dados['path'],
        fullpath: dados['fullpath'],
        gameMode: dados['game_mode'] ?? 0,
      );
      debugPrint('-> Workspace data received with success, returning----');
      return workspaceDetail;
    });
  }

  Future<bool> sendConfirmationCode(DeviceModel device) async {
    if (device.alias == '') {
      debugPrint('Empty alias...');
      return false;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi + "/device/confirm/1/" + device.code;
    debugPrint('alias-----------------');
    debugPrint(device.alias);
    debugPrint('alias:end-----------------');
    var dataInstall = {'device_id': device.alias, 'id': 0, 'code': device.code};
    return dio.post(url, data: dataInstall).then((res) async {
      debugPrint(res.toString());
      if (res.data['data']['code'] == 200) {
        debugPrint('-> Email confirmation success----');
        return true;
      } else {
        debugPrint('-> Email confirmation fail----');
        return false;
      }
    });
    //debugPrint(device.toString());
    //return true; //device;
  }

  Future<List<StaffKeyModel>> getMyPersonWorkspacesKeys(
      int personId, String workspaceName) async {
    List<StaffKeyModel> keys = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = MgrCustomDio.withAuthentication().instance;
    var url = mgr_urlapi +
        "/person/" +
        personId.toString() +
        '/' +
        workspaceName +
        "/keys";
    debugPrint('f4745 - Getting infotmation about workspaces/keys');
    debugPrint('f4745 - Url: ' + url);
    return dio.get(url).then((res) async {
      debugPrint(res.toString());
      if (res.statusCode == 200) {
        var resposta = res.data['data'];
        resposta.forEach((e) {
          keys.add(StaffKeyModel(keyvalue: e));
        });
        return keys;
      } else {
        debugPrint('f4745 - Erros');
        return [];
      }
    });
  }
}
