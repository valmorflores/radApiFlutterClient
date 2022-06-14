import '/modules/contacts/domain/repositories/contacts_repository.dart';
import '/modules/contacts/domain/usecases/get_users.dart';
import '/modules/contacts/external/api/eiapi_contact_datasource.dart';
import '/modules/contacts/infra/datasources/contact_datasource.dart';
import '/modules/contacts/infra/repositories/contact_repository_impl.dart';
import '/modules/contacts/presenter/states/contacts_state.dart';
import '/utils/custom_dio.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/material.dart';

import 'contact_serach_widget_bloc.dart';

class ContactSearchWidget extends StatefulWidget {
  @override
  _ContactSearchWidgetState createState() => _ContactSearchWidgetState();
}

class _ContactSearchWidgetState extends State<ContactSearchWidget> {
  final dio = WksCustomDio.withAuthentication().instance;
  late ContactDatasource datasource;
  late ContactsRepository repository;
  late GetUsers search;
  late ContactSearchWidgetBloc bloc;
  final _textSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datasource = EIAPIContactDatasource(dio);
    repository = ContactRepositoryImpl(datasource);
    search = GetUsersImpl(repository);
    bloc = ContactSearchWidgetBloc(search);
    //_textSearch.text = widget.id.toString();
    ///? bloc.add(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Container(
        height: 130,
        width: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(''),
            ),
            Container(
                alignment: Alignment.topCenter,
                color: Theme.of(context).colorScheme.background,
                width: MediaQuery.of(context).size.width,
                height: 77,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      controller: _textSearch,
                      onChanged: bloc.add,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                        //icon: new Icon(Icons.search),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.cancel,
                            ),
                            onPressed: () {
                              _textSearch.text = '';
                            }),
                        hintStyle: TextStyle(color: Colors.white60),
                        fillColor: Colors.amberAccent,
                        //focusColor: Colors.black,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        //fontStyle: FontStyle.italic,
                      )),
                )),
          ],
        ),
      ),
      Row(),
      Container(
        height: 240,
        color: Theme.of(context).colorScheme.background,
        child: Column(children: <Widget>[
          _listStream(),
        ]),
      ),
    ]));
  }

  Widget _listStream() {
    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Opa! Uma info na stream CONTACT-SEARCH-WIDGET...');
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
              final list = (state as SuccessState).list;
              debugPrint('Size = ' + list.length.toString());
              return Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: list.length,
                      itemBuilder: (_, id) {
                        final item = list[id];
                        return ListTile(
                          onTap: () {
                            debugPrint('Selecionado');
                            Navigator.pop(context, item.id);
                          },
                          leading: CircleAvatar(child: Icon(Icons.ac_unit)),
                          title: Text(
                            '${item.firstname}',
                          ),
                          subtitle: Text('${item.lastname}'),
                        );
                      }),
                ),
              );
            }
          } else {
            return Container();
          }
        });
  }
}
