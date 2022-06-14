import '/modules/settings/presenter/settings_advanced.dart';
import '/modules/setup/presenter/setup_const.dart';
import '/modules/setup/presenter/setup_main.dart';
import '/modules/todo/presenter/todo_crud/todo_home.dart';

import '/modules/workspaces/presenter/person_login.dart';

import 'core/application.dart';
import 'core/myhome_page.dart';
import 'core/ui/splash_screen.dart';
import 'modules/settings/presenter/settings_home.dart';
import 'modules/settings/presenter/settings_local_data.dart';
import 'modules/setup/presenter/install/system_install_options.dart';
import 'package:flutter/material.dart';
import 'modules/about/presenter/system/system_home.dart';
import 'modules/profile/presenter/profile_main.dart';

class Routes {
  Routes._();

  // static variables
  static const String splash = '/splash';
  static const String install = '/install';
  static const String home = '/home';
  static const String about = '/system';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String invite_shared_in = '/invite_shared_in';
  static const String search_external_users = '/search_external_users';
  static const String settings = '/settings';
  static const String settings_advanced = '/advsettings';
  static const String settings_local_data = '/settings_localdata';
  static const String projects = '/projects';
  static const String activities = '/activities';
  static const String tasks = '/tasks';
  static const String todo = '/todo';
  static const String courses = '/courses';
  static const String courses_add = '/courses_add';
  static const String articles = '/articles';
  static const String scanner = '/scanner';
  static const String wkspace_login = '/wkspace_login';
  static const String setup_main = '/setup_main';
  static const String setup_workspace = '/setup_workspace';
  static const String setup_userkey = '/setup_userkey';
  static const String setup_user = '/setup_user';
  static const String setup_workspace_key = '/setup_workspace_key';
  static const String login_google = '/logingoogle';
  static const String notifications = '/notifications';
  static const String setup_invite = '/setup_invite';
  static const String invites = '/invites';
  static const String urls = '/urls';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    home: (BuildContext context) => MyHomePage(
          title: '',
        ),
    about: (BuildContext context) => SystemHome(),
    profile: (BuildContext context) => ProfileMain(),

    /* Todo */
    todo: (BuildContext context) => TodoHome(),
    /* Settings */
    settings: (BuildContext context) => SettingsHome(),
    /* Tasks */
    /* Install */
    install: (BuildContext context) => SystemInstallOptions(),
    wkspace_login: (BuildContext context) => PersonLogin(),
    settings_advanced: (BuildContext context) => SettingsAdvancedHome(),
    setup_main: (BuildContext context) => SetupMain(),
    setup_workspace: (BuildContext context) =>
        SetupMain(start: STEP_WORKSPACE_INFO),
    setup_userkey: (BuildContext context) =>
        SetupMain(start: STEP_INSTALL_CODE_INFO),
    setup_user: (BuildContext context) =>
        SetupMain(start: STEP_INSTALL_USER_INFO),
    setup_workspace_key: (BuildContext context) =>
        SetupMain(start: STEP_INSTALL_CODE_WORKSPACE),
    setup_invite: (BuildContext context) =>
        SetupMain(start: STEP_YOU_ARE_INVITED),
    settings_local_data: (BuildContext context) => SettingsLocalData(),
  };
}
