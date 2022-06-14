import 'dart:io';

import '/core/constants/kroutes.dart';
import '/core/constants/ktables.dart';
import '/core/controllers/application/application_controller.dart';
import '/core/widgets/_widget_need_refresh_error.dart';
import '/core/widgets/_widget_staff_avatar.dart';
import '/modules/messages/infra/models/message_room_model.dart';
import '/modules/staff/domain/const/staff_constants.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';
import '/modules/staff/domain/usecases/get_staff_all.dart';
import '/modules/staff/external/api/eiapi_staff_datasource.dart';
import '/modules/staff/external/db/eidb_staff_datasource.dart';
import '/modules/staff/infra/datasources/staff_datasource.dart';
import '/modules/staff/infra/models/staff_model.dart';
import '/modules/staff/infra/repositories/staff_repository_impl.dart';
import '/modules/staff/presenter/controllers/staff_controller.dart';
import '/modules/staff/presenter/staff/states/staff_state.dart';
import '/utils/globals.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/utils/wks_custom_dio.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'staff_home_bloc.dart';

class StaffHome extends StatefulWidget {
  @override
  _StaffHomeState createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  StaffController _staffController = Get.put(StaffController());
  final dio = WksCustomDio.withAuthentication().instance;
  late StaffDatasource datasource;
  late StaffRepository repository;
  late GetStaffAll search;
  late StaffHomeBloc bloc; //var searchBloc = SearchBloc();
  late GlobalKey refreshKey;
  final ApplicationController _applicationController = Get.find();

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    super.initState();
    datasource = EIAPIStaffDatasource(dio);
    repository = StaffRepositoryImpl(datasource);
    search = GetStaffAllImpl(repository);
    bloc = StaffHomeBloc(search);
    _getdbLocalOrRemote();
    _staffController.loadStaffList();
  }

  // to get Remote informations
  _setToRemote() async {
    bloc.dispose();
    datasource = EIAPIStaffDatasource(dio);
    repository = StaffRepositoryImpl(datasource);
    search = GetStaffAllImpl(repository);
    bloc = StaffHomeBloc(search);
  }

  // to local get
  _setToLocal() async {
    bloc.dispose();
    datasource = EIDBStaffDatasource();
    repository = StaffRepositoryImpl(datasource);
    search = GetStaffAllImpl(repository);
    bloc = StaffHomeBloc(search);
  }

  _getdbLocalOrRemote() async {
    debugPrint('f8401 - Getting local or remote');
    var dbTable =
        app_selected_workspace_name + kWorkspaceTblSeparator + kTblStaff;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.containsKey(dbTable);
    if (result != null) {
      if (result) {
        // Exists local data
        debugPrint('f8401 - local found: ' + dbTable);
        await _setToLocal();
        bloc.add(1);
        setState(() {});
        return true;
      }
    } else {
      // datasource remote
      debugPrint(
          'f8401 - Set to remote option. local records not found:' + dbTable);
      await _setToRemote();
      bloc.add(1);
      setState(() {});
      return false;
    }
  }

  Future<Null> _refreshList() async {
    // Setting to remote
    await _setToRemote();
    bloc.add(1);
    setState(() {});
    await Future.delayed(Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          _refreshList();
        },
        child: Column(
          children: [
            Obx(() {
              debugPrint(
                  'f7777 - Atualizada informação: Clicks: ${_applicationController.count}');
              bloc.add(1);
              return Container();
            }),
            ((kIsWeb) || Platform.isLinux || Platform.isWindows)
                ? WidgetPageTitle(
                        title: 'Equipe',
                        onTap: () {
                          _refreshList();
                        },
                        context: context)
                    .render()
                : Container(),
            StreamBuilder(
                stream: bloc.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    debugPrint('f8404 - Opa! Uma info na stream Staff-HOME...');
                    final state = bloc.state;
                    if (state is StartState) {
                      return Center(child: Text(''));
                    } else if (state is ErrorState) {
                      return WidgetNeedRefreshError(
                        title: state.error.toString(),
                        workspace: app_selected_workspace_name,
                        onTap: () {
                          _refreshList();
                        },
                        context: context,
                      );
                    } else if (state is LoadingState) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: progressBar(context),
                      );
                    } else {
                      final list =
                          (state as SuccessState).list as List<StaffModel>;
                      debugPrint(
                          'f8404 - Size of data = ' + list.length.toString());

                      // Set data to applicationController, to share in all app
                      _applicationController.addStaffs(list);

                      return Expanded(
                          child: ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (_, index) {
                                StaffModel item = list[index];
                                // Parameters for room
                                MessageRoomModel _roomModel = MessageRoomModel(
                                  title: '${item.firstname} ${item.lastname}',
                                  contactsId: [0],
                                  membersId: [item.staffid],
                                  user1: app_user.staffid ?? 0,
                                  user2: (item.staffid ?? 0),
                                  type: 'single',
                                  isContact: false,
                                );

                                // Avatar
                                Widget _widget = WidgetStaffAvatar(
                                    shape: BoxShape.circle,
                                    width: 32,
                                    height: 32,
                                    urlImage:
                                        _staffController.getImageUrlByStaffId(
                                            item.staffid ?? 0));

                                return Card(
                                    child: ListTile(
                                  leading: Container(
                                      width: 32, height: 32, child: _widget),
                                  trailing: Text(item.staffid.toString()),
                                  title: Text(item.firstname ?? ''),
                                  subtitle: Text((item.lastname ?? '')),
                                  onLongPress: () {},
                                  onTap: () {
                                    debugPrint(
                                        'f0007 ---------------- Conversations of [${app_user.staffid ?? 0} x ${item.staffid ?? 0}] ----------------------');
                                    Navigator.of(context).pushNamed(
                                        kRouteMessages,
                                        arguments: _roomModel);
                                  },
                                ));
                              }));
                    }
                  }
                  return Container();
                }),
          ],
        ));
  }
}
