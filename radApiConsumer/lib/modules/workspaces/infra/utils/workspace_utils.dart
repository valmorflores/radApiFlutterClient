import '/global/resources/kconstants.dart';
import '/modules/setup/infra/models/workspace_model.dart';
import '/modules/setup/setup_load.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';

class WorkspaceUtils {
  saveCfgWorkspace(List<WorkspaceModel> snapshot) async {
    SetupLoad setup = SetupLoad();
    snapshot.forEach((item) async {
      debugPrint('f0747-> Setup saving worskapce relevant informations');
      debugPrint('f0747-> ' +
          kWorkspaceCfgPre +
          '/' +
          item.name +
          '/userkey' +
          ' => ' +
          item.workspaceKeyValue);
      await setup.saveWksParam(item.name, 'userkey', item.workspaceKeyValue);
      debugPrint('f0747-> Setup saving done.');
      // Saving workspaces to List(algo como: _listwks_0 => item.name
      debugPrint('f0748-> Save workspace to list: ' +
          kWorkspaceCfgList +
          item.id.toString() +
          ' => ' +
          item.name);
      await setup.saveWksParam(
          kWorkspaceCfgList, item.id.toString(), item.name);
      debugPrint('f0748-> done');
      debugPrint('f0749-> Save workspace domain to list: ' +
          kWorkspaceCfgList +
          item.id.toString() +
          ' => ' +
          item.name +
          '/' +
          item.domain);
      await setup.saveWksParam(kWorkspaceCfgListDomains, item.id.toString(),
          item.name + '/' + item.domain);
      await setup.saveWksParam(kWorkspaceCfgListGameMode, item.id.toString(),
          item.gameMode.toString());
      debugPrint('f0749-> id => ' + item.id.toString());
      debugPrint('f0749-> isInstalled = true');
      isInstalled = true;
      debugPrint('f0749-> done');
    });
  }
}
