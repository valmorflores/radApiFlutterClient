import '../../../modules/workspaces/domain/errors/erros.dart';
import '../../../modules/workspaces/domain/repositories/person_repository.dart';
import '../../../modules/workspaces/domain/usecases/put_login.dart';
import '../../../modules/workspaces/external/api/eiapi_person_datasource.dart';
import '../../../modules/workspaces/infra/models/person_login_model.dart';
import '../../../modules/workspaces/infra/repositories/person_repository_impl.dart';
import '../../../modules/workspaces/presenter/person_login_bloc.dart';
import '../../../modules/workspaces/presenter/states/person_state.dart';
import '../../../utils/globals.dart';
import '../../../utils/mgr_custom_dio.dart';
import '../../../utils/progress_bar/progress_bar.dart';
import '../../../core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonLogin extends StatefulWidget {
  @override
  _PersonLoginState createState() => _PersonLoginState();
}

class _PersonLoginState extends State<PersonLogin> {
  //class PersonLogin extends StatelessWidget {
  final dio = MgrCustomDio.withAuthentication().instance;
  var _isValid = false;
  late PersonLoginBloc bloc;
  late PostLogin search;
  late PersonRepository repository;
  late EIAPIPersonDatasource datasource;
  late String _name;
  late String _email;
  late SharedPreferences _prefs;

  final _userPasswordStr = TextEditingController();
  final _userEmailStr = TextEditingController();

  @override
  initState() {
    datasource = EIAPIPersonDatasource(dio);
    repository = PersonRepositoryImpl(datasource);
    search = PostLoginImpl(repository);
    bloc = PersonLoginBloc(search);
    getProprietary();
    valid().then((value) => _isValid = value);
    //bloc.add(999);
  }

  getProprietary() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = _prefs.getString('_proprietary_email')!;
      _name = _prefs.getString('_proprietary_name')!;
      _userEmailStr.text = _email;
    });
  }

  setProprietary() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('_proprietary_email', _email);
    await _prefs.setString('_proprietary_name', _name);
  }

  Future<bool> valid() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Acesso principal'),
        ),
        body: Column(
          children: [
            WidgetPageTitle(
              title: 'Dados de login',
              workspace: app_selected_workspace_name,
              context: context,
              onTap: () {},
            ).render(),
            _login(),
            FutureBuilder(
                future: valid(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container();
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
            ListTile(
              title: Text("${app_userkey}", style: TextStyle(fontSize: 24)),
              leading: Icon(Icons.vpn_key),
              subtitle: Text(
                _isValid ? 'Chave válida' : 'Clique para analisar',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                setState(() {
                  valid().then((value) => _isValid = value);
                });
              },
            ),
          ],
        ));
  }

  Widget _login() {
    return Container(
        child: Column(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                  controller: _userEmailStr,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  //style: TextStyle(color: Colors.blue, fontSize: 30),
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(color: Colors.black),
                  )),
              Divider(),
              TextField(
                  controller: _userPasswordStr,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  //style: TextStyle(color: Colors.blue, fontSize: 30),
                  decoration: InputDecoration(
                    labelText: "Senha",
                    labelStyle: TextStyle(color: Colors.black),
                  )),
              Divider(),
              ButtonTheme(
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () => {
                    setState(() {
                      bloc.add(PersonLoginModel(
                          email: _userEmailStr.text,
                          password: _userPasswordStr.text));
                    })
                  },
                  child: const Text(
                    "Enviar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //Text('...'),
    ]));
  }

  Widget _data() {
    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Opa! Uma info na stream Person-LOGIN...');
            final state = bloc.state;
            if (state is StartState) {
              return Center(child: Text(''));
            } else if (state is ErrorState) {
              if (state.error is ErrorLoginFail) {
                debugPrint(
                    'Erro de login ao executar:' + state.error.toString());
                return _errorMsg('Falha de login, credenciais inválidas');
              } else if (state.error is ErrorLoginNotFound) {
                debugPrint(
                    'Erro de login ao executar:' + state.error.toString());
                return _errorMsg('Falha de login, usuário não localizado');
              }
              debugPrint('Erro ao executar:' + state.error.toString());
              return _errorMsg('Erro no retorno do servidor');
            } else if (state is LoadingState) {
              return Center(
                child: progressBar(context),
              );
            } else {
              final list = (state as SuccessPersonLoginState);
              var item = list.person;
              _email = '${item.emails![0].email}';
              _name = '${item.alias} ${item.name}';
              setProprietary();
              //debugPrint('Size = ' + list.person());
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
                    subtitle: Text('${item.emails![0].email}'),
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

  _errorMsg(String text) {
    return Container(
        width: double.infinity,
        color: Colors.amber,
        child:
            Padding(padding: const EdgeInsets.all(8.0), child: Text('$text')));
  }
}
