import '/modules/todo/infra/blocs/todo_update_multi_bloc.dart';
import '/modules/todo/infra/states/todo_state.dart' as default_state;
import '/modules/todo/infra/states/todo_state_multiupdate.dart'
    as multiupdate_state;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/modules/todo/infra/blocs/todo_update_bloc.dart';
import '/utils/progress_bar/progress_bar.dart';

// ignore: must_be_immutable
class TodoSync extends StatefulWidget {
  TodoUpdateBloc updateBloc;
  TodoUpdateMultiBloc multiUpdateBloc;

  TodoSync({
    Key? key,
    required this.updateBloc,
    required this.multiUpdateBloc,
  }) : super(key: key);

  @override
  _TodoSyncState createState() => _TodoSyncState();
}

class _TodoSyncState extends State<TodoSync> {
  @override
  Widget build(BuildContext context) {
    var appBarSize = AppBar().preferredSize.height;
    // todo: valmor, ver modo melhor - plus safeArea?
    appBarSize += 0;
    return Container(
      height: appBarSize,
      child: Stack(children: [
        updateSync(),
        updateMultiBloc(),
      ]),
    );
  }

  updateSync() {
    return StreamBuilder(
        stream: widget.updateBloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint(
                'f6001 - todo_sync say: Opa! Uma info na stream TODOUPDATE...');
            final state = widget.updateBloc.state;
            if (state is default_state.StartState) {
              return Center(child: Text(''));
            } else if (state is default_state.ErrorState) {
              return Center(
                  child: Text('Erro ao executar:' + state.error.toString()));
            } else if (state is default_state.LoadingState) {
              return Positioned(
                  top: 0,
                  left: 0,
                  child: Center(
                    child: progressBar(context),
                  ));
            } else {
              final list = (state as default_state.SuccessState).list;
              debugPrint('f6001 - Do update Size = ' + list.length.toString());
              return Container();
              /*Expanded(
                child: SizedBox(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: list.length,
                      itemBuilder: (_, id) {
                        final item = list[id];
                        return ListTile(
                          onTap: () {},
                          title: Text(
                            item.description,
                          ),
                          subtitle: Text(item.todoid.toString()),
                        );
                      }),
                ),
              );*/
            }
          } else {
            return Container();
          }
        });
  }

  updateMultiBloc() {
    if (widget.multiUpdateBloc == null) {
      return Container();
    } else {
      return StreamBuilder(
          stream: widget.multiUpdateBloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              debugPrint(
                  'f6092 - todo_sync say: Opa! Uma info na stream TODO/UPDATEMULTI...');
              final state = widget.multiUpdateBloc.state;
              if (state is multiupdate_state.StartState) {
                //return Center(child: Text(''));
                return Container();
              } else if (state is multiupdate_state.ErrorState) {
                //return Center(
                //    child: Text('Erro ao executar:' + state.error.toString()));
                return Container();
              } else if (state is multiupdate_state.LoadingState) {
                //return Container();
                return Positioned(
                    top: 0,
                    left: 0,
                    child: Center(
                      child: progressBar(context),
                    ));
              } else {
                final list = (state as multiupdate_state.SuccessState).list;
                debugPrint(
                    'f6092 - Do update Size = ' + list.length.toString());
                return Container();
                /*Expanded(
                child: SizedBox(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: list.length,
                      itemBuilder: (_, id) {
                        final item = list[id];
                        return ListTile(
                          onTap: () {},
                          title: Text(
                            item.description,
                          ),
                          subtitle: Text(item.todoid.toString()),
                        );
                      }),
                ),
              );*/
              }
            } else {
              return Container();
            }
          });
    }
  }
}
