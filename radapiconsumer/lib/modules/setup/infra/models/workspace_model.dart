class WorkspaceModel {
  int index;
  int id;
  String name;
  String path;
  String fullpath;
  String domain;
  String server;
  String workspaceKeyValue;
  int gameMode;

  WorkspaceModel({
    this.index = 0,
    this.id = 0,
    this.name = '',
    this.server = '',
    this.path = '',
    this.fullpath = '',
    this.domain = '',
    this.workspaceKeyValue = '',
    this.gameMode = 0,
  });
}
