import '/modules/setup/external/api/mgr_workspace_repository.dart';
import '/modules/setup/infra/models/device_model.dart';
import '/modules/setup/infra/models/setup_install_vars.dart';
import '/modules/setup/infra/models/workspace_model.dart';
import '/modules/workspaces/infra/models/person_model.dart';
import '/modules/workspaces/infra/utils/workspace_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WorkspaceController extends GetxController {
  var count = 0.obs;
  RxList workspacesList = <WorkspaceModel>[].obs;
  MgrWorkspaceRepository _workspaceRepository = MgrWorkspaceRepository();
  var _device = DeviceModel();

  void increment() {
    count++;
    update();
  }

  void add(WorkspaceModel workspaceModel) {
    workspacesList.add(workspaceModel);
    update();
  }

  // Start http to ge informations about person and workspaces
  loadPersonComplete() async {
    late PersonModel _person;
    _device = setup_app_device!;

    debugPrint('f7088 - getting myPerson related wirth this device...');
    _person = await _workspaceRepository.getMyPerson(_device);

    debugPrint('f7088 - Getting list of workspaces from myPerson...');
    List<WorkspaceModel> _workspaces =
        await (_workspaceRepository.getMyPersonWorkspaces(_person));

    debugPrint('f7088 - Receive information -> Size = ' +
        (_workspaces).length.toString());

    debugPrint('f7088 - Mounting a workspaces list');
    _workspaces.forEach((element) {
      workspacesList.add(element);
    });

    debugPrint('f7088 - loadPersonComplete() done');
  }

  // Save Local workspaces (keys) and important data
  saveWorkspaces() {
    List<WorkspaceModel> _list = [];
    workspacesList.forEach((element) {
      _list.add(element);
    });
    WorkspaceUtils().saveCfgWorkspace(_list);
  }

  Future<bool> createNewWorkspace(String workspaceName) async {
    WorkspaceModel workspaceResult =
        await _workspaceRepository.create(workspaceName, _device.alias);
    if (workspaceResult.id == null) {
      workspaceResult.id = 0;
    }
    if (workspaceResult.id > 0) {
      debugPrint('Tudo certo, workspace criado com sucesso');
      return true;
    } else if (workspaceResult.id <= 0) {
      debugPrint('Criação negada');
      return false;
    }
    return false;
  }
}
