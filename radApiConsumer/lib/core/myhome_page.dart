import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes.dart';
import '../utils/themes/system_theme_data.dart';
import '/core/api/notification_api.dart';
import 'package:radapiconsumer/modules/profile/presenter/profile_main.dart';
import '/modules/clients/presenter/client/client_add.dart';
import '/modules/setup/presenter/controllers/policies_controller.dart';
import '/modules/setup/presenter/policies/policies_notification.dart';
import '/modules/staff/presenter/controllers/staff_controller.dart';
import 'package:flutter/foundation.dart';
import '/modules/clients/presenter/client/client_home.dart';
import '/modules/contacts/presenter/contact_home.dart';
import '/modules/setup/setup_load.dart';
import '/utils/keep_alive_page.dart';
import '/modules/menu/presenter/menu.dart';
import '/modules/menu_left/domain/classes/wokspace_selector.dart';
import '../core/enums/enum_awards.dart';
import '../core/enums/enum_notifications.dart';
import '../global/repositories/login_repository.dart';
import '../global/resources/kconstants.dart';
import '../modules/awards/presenter/view_award_component/award_component.dart';
import '../modules/staff/presenter/staff/staff_home.dart';
import '../utils/globals.dart';
import '../modules/menu_left/presenter/menu_left_drawer.dart';
import 'controllers/application/application_controller.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

GlobalKey<ScaffoldState> _globalKeyScaffoldMain =
    GlobalKey<ScaffoldState>(debugLabel: '_homeScreenkey');

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final StaffController _staffController = Get.put(StaffController());
  final PoliciesController _policiesController = Get.put(PoliciesController());
  final pageController = PageController(initialPage: 0);
  final menu = Menu();
  int _notificationsQty = 0;
  int _notificationsAwardQty = 0;

  late ApplicationController applicationController;

  // For INTENT receive
  late StreamSubscription _intentDataStreamSubscription;

  late String _sharedText;

  //*------------
  @override
  void initState() {
    applicationController = Get.put(ApplicationController());
    NotificationApi.init();
    listenNotifications();
    loadSetupApp();
    login();
    getTheme();
    getThemeColor();
    if (app_selected_workspace_name != '') {
      getStaffList();
    }
    super.initState();
    if (kIsWeb) {
    } else if (Platform.isAndroid || Platform.isIOS) {}
    // INTENT end
  }

  getStaffList() {
    _staffController.loadStaffList();
  }

  @override
  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String payload) async {
    if (payload.isNotEmpty) {
      debugPrint('f7714 - From notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => ProfileMain()),
    );
  }

  // Carrega informações iniciais (setup deste device)
  loadSetupApp() async {
    debugPrint('f7800 - SetupLoad: Creating instance');
    SetupLoad setupLoad = SetupLoad();
    debugPrint('f7800 - SetupLoad: Getting initial data');
    await setupLoad.loadAppState();
    if (app_selected_workspace_name == null) {
      debugPrint('f7800 - SetupLoad: workspaces not load, first time here...');
    } else {
      var _isNotEmpty = app_selected_workspace_name.isNotEmpty;
      if (_isNotEmpty) {
        debugPrint('f7800 - SetupLoad: Workspace selected => ' +
            app_selected_workspace_name);
        debugPrint(
            'f7800 - SetupLoad: Selecting workspace via WorkspaceSelector class...');
        WorkspaceSelector _workspaceSelector;
        _workspaceSelector = WorkspaceSelector();
        await _workspaceSelector.select(app_selected_workspace_name);
        Get.forceAppUpdate();
      }
    }
    debugPrint('f7800 - SetupLoad: Done');
  }

  Future getThemeColor() async {
    String _themeColor;
    String _themeMode;
    await SharedPreferences.getInstance().then((prefs) async {
      _themeColor = prefs.getString('theme_color') ?? '1';
      _themeMode = prefs.getString('theme') ?? '1';
      // debugPrint(
      //     'f0501 - themeColor: ${_themeColor} themeMode: ${_theme_mode}');
      if (_themeColor == '1') {
        if (_themeMode == '1') {
          Get.changeTheme(SystemThemeData.lightThemeData1);
        } else {
          Get.changeTheme(SystemThemeData.darkThemeData1);
        }
      }
      if (_themeColor == '2') {
        if (_themeMode == '1') {
          Get.changeTheme(SystemThemeData.lightThemeData2);
        } else {
          Get.changeTheme(SystemThemeData.darkThemeData2);
        }
      }
      if (_themeColor == '3') {
        if (_themeMode == '1') {
          Get.changeTheme(SystemThemeData.lightThemeData3);
        } else {
          Get.changeTheme(SystemThemeData.darkThemeData3);
        }
      }
      if (_themeColor == '0') {
        if (_themeMode == '1') {
          Get.changeTheme(SystemThemeData.lightThemeData0);
        } else {
          Get.changeTheme(SystemThemeData.darkThemeData0);
        }
      }
    });
  }

  Future getTheme() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String? _themeMode = await prefs.getString('theme');
    //debugPrint('f0500 - Theme: ${_theme_mode}');
    if (_themeMode == '1') {
      Get.changeThemeMode(ThemeMode.light);
    } else if (_themeMode == '2') {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
    return _themeMode;
  }

  login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = (await prefs.getString('myuserkey')) ?? '';
    String _isValid =
        (await prefs.getString('key_' + userKey + '_is_valid')) ?? '';
    String _isActive =
        (await prefs.getString('key_' + userKey + '_is_active')) ?? '';

    debugPrint('f0723 - _key' + userKey + '_is_valid' + _isValid);
    debugPrint('f0723 - _key' + userKey + '_is_active' + _isActive);
    try {
      final result = await LoginRepository().login();
      //.then(
      if (result) {
        if (userKey != '') {
          isInstalled = true;
        }
        //debugPrint(successCallback);
        //    },
        //onError: (e) {
        //  debugPrint('f0723 - Display error-> ' + e.toString());
        //});
      }
    } catch (e) {
      debugPrint('f0723 - Error in login');
      debugPrint('f0723 - Display error-> ' + e.toString());
    }
    if (userKey == "") {
      debugPrint('f0723 - is not installed');
      bool _selectedWorkspace = false;
      if (app_selected_workspace_name != '') {
        _selectedWorkspace = app_selected_workspace_name.isNotEmpty;
      }
      // if selectedWorkspace, installed is ok,
      // verificar um modo de validar a myuserkey
      isInstalled = _selectedWorkspace;
      (isInstalled)
          ? debugPrint('f0723 - but exists workspace, is installed true')
          : debugPrint('f0723 - does not exists workspace, is installed false');
      //_navigateAndInstall(context: this.context);
    } else if (_isValid == "1") {
      isInstalled = true;
    }
    // policies, get state
    _policiesController.getPoliciesState().then((value) {
      if (value == PoliciesState.isUndefined) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PoliciesNotification()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return appScaffold();
  }

  Scaffold appScaffold() {
    var _tabFontSize = MediaQuery.of(context).size.width < 500
        ? kVisualTabBarFontSizeMobile
        : kVisualTabBarFontSizeDesktop;
    bool _selectedWorkspace = false;
    EIAwardsNotifications _notificationAward =
        EIAwardsNotifications.notifyNotEmpty;
    EINotifications _notificationWorkspace =
        EINotifications.notifyUnknowWorkspace;
    if (app_selected_workspace_name != '') {
      _selectedWorkspace = app_selected_workspace_name.isNotEmpty;
    }
    if (_selectedWorkspace) {
      // todo: = analise, if exists
      _notificationWorkspace = EINotifications.notifyNotEmpty;
    }

    return Scaffold(
      key: _globalKeyScaffoldMain,
      drawer: MenuLeftDrawer(),
      onDrawerChanged: (v) {
        debugPrint('f6780 - DrawerMenuChanged: ' + v.toString());
        // v = false, closing drawer
        // Is possible changes of workspace or user
        // run important updates here
        v
            ? setState(() {
                _notificationsQty = 0;
              })
            : null;
        !v
            ? Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  debugPrint('f6780 - DrawerMenuChanged: getNotification run');
                });
              })
            : null;
      },
      appBar: AppBar(
        /*backgroundColor: pageController.position == 0
            ? Theme.of(context).colorScheme.primary.withAlpha(200)
            : null,*/
        bottom: !_selectedWorkspace
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(kVisualTabBarHeight),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                      labelPadding: const EdgeInsets.only(left: 10, right: 10),
                      isScrollable: true,
                      tabs: [
                        SizedBox(
                          height: kVisualTabBarHeight,
                          child: Tab(
                            child: Text('Menu',
                                style: TextStyle(
                                  fontSize: _tabFontSize,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: kVisualTabBarHeight,
                          child: Tab(
                              child: Text('Contatos',
                                  style: TextStyle(
                                    fontSize: _tabFontSize,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ))),
                        ),
                        SizedBox(
                          height: kVisualTabBarHeight,
                          child: Tab(
                              child: Text('Instituições',
                                  style: TextStyle(
                                    fontSize: _tabFontSize,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ))),
                        ),
                        SizedBox(
                          height: kVisualTabBarHeight,
                          child: Tab(
                              child: Text('Equipe',
                                  style: TextStyle(
                                    fontSize: _tabFontSize,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ))),
                        ),
                      ],
                      onTap: (i) {
                        pageController.animateToPage(i,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInQuint);
                      }),
                ),
              ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Busca',
              onPressed: () =>
                  {Navigator.of(context).pushNamed(Routes.search)}),
        ],
        title:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Flexible(
              child: Text(app_selected_workspace_name,
                  style: const TextStyle(
                      fontFamily: 'roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold))),
          SizedBox(width: _selectedWorkspace ? 5 : 0),
          _selectedWorkspace
              ? GestureDetector(
                  onTap: () {
                    NotificationApi.showNotification(
                        title: 'RadApi Client',
                        body:
                            'Você está no seu ambiente $app_selected_workspace_name',
                        payload: 'Inicie uma atividade nova');
                  },
                  child: Icon(
                    Icons.home_filled,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 30.0,
                  ))
              : Container(),
          AwardComponent(
            notification: _notificationAward,
            qty: _notificationsAwardQty,
          ),
          SizedBox(
            width: _selectedWorkspace ? 5 : 0,
          ),
          MediaQuery.of(context).size.width < 350
              ? Container()
              : MediaQuery.of(context).size.width < 500 && _selectedWorkspace
                  ? Container(
                      child: const Text(
                        'eiApp',
                        style: TextStyle(
                            fontFamily: 'roboto',
                            fontSize: 11,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : Flexible(
                      child: Text(
                      widget.title,
                      style: const TextStyle(
                          fontFamily: 'roboto',
                          fontSize: 11,
                          fontWeight: FontWeight.normal),
                    )),
          MediaQuery.of(context).size.width > 1024
              ? InkWell(
                  child: const Icon(Icons.upload_file),
                  onTap: () {},
                )
              : Container()
        ]),
      ),

      body: PageView(
          onPageChanged: (int) {
            DefaultTabController.of(context)!.animateTo(int);
          },
          controller: pageController,
          children: [
            KeepAlivePage(
                child: SingleChildScrollView(
                    child: Column(
              children: [Menu()],
            ))),
            KeepAlivePage(child: ContactHome()),
            KeepAlivePage(child: ClientHome()),
            KeepAlivePage(child: StaffHome())
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (pageController.page == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClientAdd()),
            );
          }
        },
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
