import 'package:dio/dio.dart';
import '/modules/contacts/domain/repositories/contacts_repository.dart';
import '/modules/contacts/domain/usecases/get_by_id.dart';
import '/modules/contacts/external/api/eiapi_contact_datasource.dart';
import '/modules/contacts/infra/datasources/contact_datasource.dart';
import '/modules/contacts/infra/repositories/contact_repository_impl.dart';
import '/utils/custom_dio.dart';
import '/utils/phonecall_util.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/utils/wks_custom_dio.dart';
import '/modules/clients/presenter/client/client_detail.dart';
import 'package:flutter/material.dart';

import 'contact_detail_bloc.dart';
import 'states/contacts_state.dart';

// ignore: must_be_immutable
class ContactDetailHome extends StatefulWidget {
  int id;
  ContactDetailHome({Key? key, required this.id}) : super(key: key);

  @override
  _ContactDetailHomeState createState() => _ContactDetailHomeState();
}

class _ContactDetailHomeState extends State<ContactDetailHome> {
  int instituicao = 0;
  String _contactName = '';
  final _textSearch = TextEditingController();
  final dio = WksCustomDio.withAuthentication().instance;
  late ContactDatasource datasource;
  late ContactsRepository repository;
  late GetById search;
  late ContactDetailBloc bloc; //var searchBloc = SearchBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datasource = EIAPIContactDatasource(dio);
    repository = ContactRepositoryImpl(datasource);
    search = GetByIdImpl(repository);
    bloc = ContactDetailBloc(search);
    //_textSearch.text = widget.id.toString();
    bloc.add(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Contato')),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: SafeArea(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: double.infinity,
                  color: Theme.of(context)
                      .colorScheme
                      .background, //Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      Row(),
                      _listStream(),
                      Expanded(
                        child: Container(),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: _menu_options()),
                    ],
                  )),
            ],
          ),
        )));
  }

  Widget _menu_options() {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
            child: Text('Mais informações'),
            onPressed: () {
              _showModalMenu();
            }));
  }

  void _showModalMenu() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 220,
            child: _menu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(14),
                    topRight: const Radius.circular(14))),
          );
        });
  }

  Widget _menu() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.home_outlined),
          title: Text('Dados da instituição'),
          onTap: () {
            // load data
            if (instituicao > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClientDetail(id: instituicao)),
              );
            }
          },
        ),
        ListTile(
            leading: Icon(Icons.archive_outlined),
            title: Text('Tíquetes'),
            onTap: () {
              // load data
            }),
        ListTile(
          leading: Icon(Icons.book_online),
          title: Text('Cursos'),
          onTap: () {
            // load data
          },
        ),
        ListTile(
          leading: Icon(Icons.inbox),
          title: Text('Convites'),
          onTap: () {
            // load data
          },
        )
      ],
    );
  }

  Widget _listStream() {
    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Opa! Uma info CONTACT na stream...');
            final state = bloc.state;
            if (state is StartState) {
              return _areaLoading();
            } else if (state is ErrorState) {
              return Center(
                  child: Text('Erro ao executar:' + state.error.toString()));
            } else if (state is LoadingState) {
              return _areaLoading();
            } else {
              final list = (state as SuccessState).list;
              debugPrint('Size = ' + list.length.toString());
              return Container(
                height: MediaQuery.of(context).size.height - 150,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: list.length,
                    itemBuilder: (_, id) {
                      final item = list[id];
                      instituicao = item.userid!;
                      _contactName = item.firstname!;
                      return Column(children: [
                        Container(
                          width: double.infinity,
                          color: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 8, 12, 8),
                            child: Row(children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('$_contactName',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3)),
                              (item.active == '0'
                                  ? Chip(label: Text('inativo'))
                                  : Container()),
                            ]),
                          ),
                        ),
                        ListTile(
                            title: const Text(
                              'Id',
                            ),
                            subtitle: Text(
                              '${item.id}',
                            )),
                        ListTile(
                          title: Text(
                            item.firstname!,
                          ),
                          subtitle: Text(
                            item.lastname!,
                          ),
                        ),
                        ListTile(
                          title: Text('Cargo'),
                          subtitle: Text('${item.title}'),
                        ),
                        ListTile(
                          title: Text('Telefone'),
                          subtitle: Text('${item.phonenumber}'),
                          onTap: () {
                            var _phone = item.phonenumber;
                            var _launched =
                                PhoneCallUtil().makePhoneCall('tel:$_phone');
                          },
                        ),
                        ListTile(
                          title: Text('E-mail'),
                          subtitle: Text('${item.email}'),
                        ),
                        ListTile(
                          title: Text('E-mail secundário'),
                          subtitle: Text('${item.email}'),
                        )
                      ]);
                    }),
              );
            }
          } else {
            return _areaLoading();
          }
        });
  }

  Widget _areaLoading() {
    return progressBar(context);
  }
}
