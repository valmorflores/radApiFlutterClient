import 'dart:io';

import '/core/constants/ktables.dart';
import '/core/controllers/application/application_controller.dart';
import '/core/widgets/_widget_dialog_confirm_remove.dart';
import '/core/widgets/_widget_need_refresh_error.dart';
import '/modules/contacts/domain/const/contacts_constants.dart';
import '/modules/contacts/domain/repositories/contacts_repository.dart';
import '/modules/contacts/domain/usecases/get_all.dart';
import '/modules/contacts/external/api/eiapi_contact_datasource.dart';
import '/modules/contacts/external/db/eidb_contact_datasource.dart';
import '/modules/contacts/infra/datasources/contact_datasource.dart';
import '/modules/contacts/infra/models/contact_model.dart';
import '/modules/contacts/infra/repositories/contact_repository_impl.dart';
import '/modules/contacts/presenter/contact_detail_home.dart';
import '/modules/contacts/external/api/direct_contacts_repository.dart';

import '/modules/contacts/presenter/controllers/contact_controller.dart';
import '/modules/contacts/presenter/states/contacts_state.dart';
import '/utils/globals.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/utils/wks_custom_dio.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../views/contact/../../modules/contacts/presenter/contact_home_help_assistent.dart';
import 'contact_home_bloc.dart';

class ContactHome extends StatefulWidget {
  @override
  _ContactHomeState createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHome> {
  late ApplicationController _applicationController;
  late ContactController _contactController = Get.put(ContactController());
  late Future<List<ContactModel>> contacts;
  final dio = WksCustomDio.withAuthentication().instance;
  late ContactDatasource datasource;
  late ContactsRepository repository;
  late GetAll search;
  late ContactHomeBloc bloc; //var searchBloc = SearchBloc();
  late GlobalKey refreshKey;
  List<int> _selectedList = [];

  @override
  void initState() {
    _applicationController = Get.find();
    debugPrint('f0005 - Starting ContactsHome');
    refreshKey = GlobalKey<RefreshIndicatorState>();
    super.initState();
    _setToLocal();
    _getdbLocalOrRemote();
    //LoginRepository().login();
    //_contactRepository = DirectContactRepository();
    //contacts = _contactRepository.getAll();
  }

  // to get Remote informations
  _setToRemote() async {
    datasource = EIAPIContactDatasource(dio);
    repository = ContactRepositoryImpl(datasource);
    search = GetAllImpl(repository);
    bloc = ContactHomeBloc(search);
  }

  // to local get
  _setToLocal() async {
    datasource = EIDBContactsDatasource();
    repository = ContactRepositoryImpl(datasource);
    search = GetAllImpl(repository);
    bloc = ContactHomeBloc(search);
  }

  Future<bool> _getdbLocalOrRemote() async {
    debugPrint('f7401 - Getting local or remote');
    var dbTable =
        app_selected_workspace_name + kWorkspaceTblSeparator + kTblContacts;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.containsKey(dbTable);
    if (result != null) {
      if (result) {
        // Exists local data
        debugPrint('f7401 - local found: ' + dbTable);
        await _setToLocal();
        bloc.add(1);
        setState(() {});
        return true;
      }
    } else {
      // datasource remote
      debugPrint('f7401 - Remote option, records not found:' + dbTable);
      await _setToRemote();
      bloc.add(1);
      setState(() {});
      return false;
    }
    return true;
  }

  Future<Null> refreshList() async {
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
          await refreshList();
        },
        child: Scaffold(
            bottomNavigationBar: _showMenu(),
            body: Column(children: [
              Obx(() {
                debugPrint(
                    'f7777 - Updating contacts: Clicks: ${_applicationController.count}');
                bloc.add(1);
                return Container();
              }),
              ((kIsWeb) || Platform.isLinux || Platform.isWindows)
                  ? WidgetPageTitle(
                          title: 'Contato',
                          onTap: () {
                            refreshList();
                          },
                          context: context)
                      .render()
                  : Container(),
              ContactHomeHelpAssistent(),
              StreamBuilder(
                  stream: bloc.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final state = bloc.state;
                      if (state is StartState) {
                        return Center(child: Text(''));
                      } else if (state is ErrorState) {
                        return WidgetNeedRefreshError(
                          title: state.error.toString(),
                          workspace: app_selected_workspace_name,
                          onTap: () {
                            refreshList();
                          },
                          context: context,
                        );
                      } else if (state is LoadingState) {
                        return Align(
                            alignment: Alignment.topCenter,
                            child: progressBar(context));
                      } else {
                        final List list = (state as SuccessState).list;
                        debugPrint('Size = ' + list.length.toString());

                        return Expanded(
                            child: ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (_, index) {
                                  ContactModel item = list[index];
                                  return Card(
                                      child: ListTile(
                                    trailing: Icon(item.active == '1'
                                        ? Icons.check
                                        : Icons.close),
                                    title: Text(
                                        item.firstname! + ' ${item.lastname}'),
                                    subtitle: Text(item.email!),
                                    selected:
                                        (_selectedList.indexOf(item.id ?? -1) >=
                                            0),
                                    onLongPress: () {
                                      setState(() {
                                        if (_selectedList.indexOf(
                                                item.id ?? 0, 0) >
                                            0) {
                                          _selectedList.removeWhere(
                                              (element) => element == item.id!);
                                        } else {
                                          _selectedList.add(item.id ?? -1);
                                        }
                                      });
                                      setState(() {});
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContactDetailHome(
                                                    id: item.id!)),
                                      );
                                    },
                                  ));
                                }));
                      }
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: progressBar(context),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            Text('Error: {$snapshot.error}'),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ])));
  }

  _showMenu() {
    if (_selectedList.length > 0) {
      return Container(
        height: 50,
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
              ),
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.delete),
                  ),
                  onTap: () {
                    _removeBtnDo();
                  }),
              const Spacer(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
                onTap: () {
                  setState(() {
                    _selectedList.clear();
                  });
                },
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              Container(
                width: 30,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  _removeBtnDo() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return WidgetDialogConfirmRemove(onTap: () async {
            //todo: delete where _selectedList
            _selectedList.forEach((element) {
              _contactController.delete(element);
            });
            Navigator.of(context).pop();
            bloc.add(1);
          });
        });
  }
}
