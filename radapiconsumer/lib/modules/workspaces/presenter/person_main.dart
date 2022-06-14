import '/global/repositories/login_repository.dart';
import '/modules/workspaces/domain/repositories/person_repository.dart';
import '/modules/workspaces/domain/usecases/get_by_id.dart';
import '/modules/workspaces/domain/usecases/get_details_by_id.dart';
import '/modules/workspaces/external/api/eiapi_person_datasource.dart';
import '/modules/workspaces/infra/repositories/person_repository_impl.dart';
import '/modules/workspaces/presenter/states/person_state.dart';
import '/modules/setup/presenter/install/page_install_user_code.dart';
import '/utils/custom_dio.dart';
import '/utils/globals.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'person_main_bloc.dart';

class PersonMain extends StatefulWidget {
  @override
  _PersonMainState createState() => _PersonMainState();
}

class _PersonMainState extends State<PersonMain> {
  //class PersonMain extends StatelessWidget {
  final dio = CustomDio.withAuthentication().instance;
  var _isValid = false;
  late PersonMainBloc bloc;
  late GetById search;
  late PersonRepository repository;
  late EIAPIPersonDatasource datasource;
  late String _name;
  late String _email;
  late SharedPreferences _prefs;

  @override
  initState() {
    datasource = EIAPIPersonDatasource(dio);
    repository = PersonRepositoryImpl(datasource);
    search = GetByIdImpl(repository);
    bloc = PersonMainBloc(search);
    getProprietary();
    valid().then((value) => _isValid = value);
    bloc.add(999);
  }

  getProprietary() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = _prefs.getString('_proprietary_email')!;
      _name = _prefs.getString('_proprietary_name')!;
    });
  }

  setProprietary() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('_proprietary_email', _email);
    await _prefs.setString('_proprietary_name', _name);
  }

  Future<bool> valid() async {
    return await LoginRepository().isValidKey(app_userkey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
        ),
        body: Column(
          children: [
            WidgetPageTitle(
              title: 'Meus dados',
              context: context,
              onTap: () {},
            ).render(),
            FutureBuilder(
                future: valid(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == false) {
                      return Container(
                        width: double.infinity,
                        color: Colors.amber,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Chave Inválida',
                              style: TextStyle(color: Colors.black),
                            )),
                      );
                    } else {
                      //setState(() {});
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                }),
            _data(),
            _name != ''
                ? Card(
                    child: ListTile(
                      title: Text(
                        '${_name}',
                      ),
                      leading: Icon(Icons.perm_identity_outlined),
                      subtitle: Text('$_email'),
                    ),
                  )
                : Container(),
            Card(
              child: ListTile(
                title: Text("${app_userkey}", style: TextStyle(fontSize: 24)),
                leading: Icon(Icons.vpn_key),
                subtitle: Text(
                  _isValid ? 'Chave válida' : 'Clique para analisar',
                  style: TextStyle(color: Colors.green),
                ),
                onLongPress: () {
                  _navigateAndInstall(context: context);
                },
                onTap: () {
                  setState(() {
                    valid().then((value) => _isValid = value);
                  });
                },
              ),
            ),
          ],
        ));
  }

  Widget _data() {
    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Opa! Uma info na stream Person-MAIN...');
            final state = bloc.state;
            if (state is StartState) {
              return Center(child: Text(''));
            } else if (state is ErrorState) {
              return Center(
                  child: Text('Erro ao executar:' + state.error.toString()));
            } else if (state is LoadingState) {
              return Center(
                child: progressBar(context),
              );
            } else {
              final list = (state as SuccessPersonLoginState);
              var item = list.person;
              _email = '${item.name}';
              _name = '${item.alias} ${item.name}';
              setProprietary();
              //debugPrint('Size = ' + list.length.toString());
              return Expanded(
                  child: Container(
                color: Theme.of(context).colorScheme.background,
                child: Column(children: [
                  ListTile(
                    title: Text(
                      'Id',
                    ),
                    subtitle: Text('${item.id}'),
                  ),
                  ListTile(
                    title: Text(
                      'E-mail',
                    ),
                    subtitle: Text('${item.alias}'),
                  ),
                  ListTile(
                    title: Text(
                      'Name',
                    ),
                    subtitle: Text('${item.name}'),
                  ),
                ]),
              ));
            }
          } else {
            return Container();
          }
        });
  }

  _navigateAndInstall({required BuildContext context}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageInstallUserCode()),
    );

    if (result != "") {
      setState(() async {
        await LoginRepository().setUserKey(result);
        valid();
      });
    }
  }
}
