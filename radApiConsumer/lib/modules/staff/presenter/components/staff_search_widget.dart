import '/modules/staff/domain/repositories/staff_repository.dart';
import '/modules/staff/domain/usecases/get_staff_all.dart';
import '/modules/staff/external/api/eiapi_staff_datasource.dart';
import '/modules/staff/infra/datasources/staff_datasource.dart';
import '/modules/staff/infra/repositories/staff_repository_impl.dart';
import '/modules/staff/presenter/staff/states/staff_state.dart';
import '/utils/custom_dio.dart';
import '/utils/progress_bar/progress_bar.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/material.dart';

import 'staff_serach_widget_bloc.dart';

class StaffSearchWidget extends StatefulWidget {
  @override
  _StaffSearchWidgetState createState() => _StaffSearchWidgetState();
}

class _StaffSearchWidgetState extends State<StaffSearchWidget> {
  final dio = WksCustomDio.withAuthentication().instance;
  late StaffDatasource datasource;
  late StaffRepository repository;
  late GetStaffAll search;
  late StaffSearchWidgetBloc bloc;
  final _textSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datasource = EIAPIStaffDatasource(dio);
    repository = StaffRepositoryImpl(datasource);
    search = GetStaffAllImpl(repository);
    bloc = StaffSearchWidgetBloc(search);
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
            debugPrint('Opa! Uma info na stream STAFF-SEARCH-WIDGET...');
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
                            Navigator.pop(context, item.staffid);
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
