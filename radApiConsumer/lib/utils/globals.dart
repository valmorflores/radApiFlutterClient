library globals;

import '/modules/profile/infra/models/profile_model.dart';

// Mgr API
// String urlapi =
String mgr_urlapi = 'https://criativa.app/work/ei/workspace_manager/v1';
String mgr_apikey = '';
String mgr_userKey = '';
String mgr_systemEIsecret = '987616';

// Globals informations
bool isInstalled = true;

// App Api ao workspace direcionado/selecionado (ex. cosems.rs)
//String app_urlapi = 'http://localhost:89/dev/radApi/public/v1';
String app_urlapi = 'http://localhost/dev/pls_server/api/radApi/public/v1';

String app_apikey = '';
String app_userkey = '';
String app_workspace_name = '';
String app_selected_workspace_name = '';
int app_game_mode = 0;
bool app_invite_accepted = false;
String app_invite = '';
ProfileModel app_user = ProfileModel();
