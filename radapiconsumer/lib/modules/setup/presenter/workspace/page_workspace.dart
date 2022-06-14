import '/modules/setup/presenter/workspace/controllers/workspace_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../setup_text.dart';
import '../setup_title.dart';

class PageWorkspace extends StatefulWidget {
  @override
  _PageWorkspaceState createState() => _PageWorkspaceState();
}

final String strTitle = 'Workspace';
final String strTextNew = 'Digite abaixo seu nome de Workspace desejado.';
final String strTextlocated =
    'Encontramos alguns workspaces vinculados a você. Um deles é pessoal, portanto, vamos apenas habilitar o mesmo neste disposivo e você já pode começar a usá-lo.';

final Widget svg = SvgPicture.asset(
  "assets/svg/" "undraw_Profile_data_re_v81r.svg",
);

class _PageWorkspaceState extends State<PageWorkspace> {
  var _formKey = GlobalKey<FormState>();
  String _theInputWorkspace = '';
  WorkspaceController workspaceController = Get.put(WorkspaceController());
  TextEditingController fieldWorkspaceController = TextEditingController();

  @override
  void initState() {
    debugPrint('f7088 - initState from PageWorkspace()...');
    workspaceController.loadPersonComplete();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _layout();
  }

  // Imagem com meia largura para layout lateral
  Widget _image() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height - 100,
      child: Container(
          decoration: BoxDecoration(color: Colors.pink),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: svg,
          )),
    );
  }

  // Imagem em caixa para layout vertical
  Widget _imageBox() {
    return SizedBox(
      height: (MediaQuery.of(context).size.height / 2) - 100,
      child: Container(
          decoration: BoxDecoration(color: Colors.pink),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: svg,
          )),
    );
  }

  Widget _createWorkspaceBtn() {
    return MaterialButton(
      child: Text(
        'Criar e validar meu workspace',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        // Criar o workspace
        debugPrint(
            'f7080 - Creating new workspace:' + fieldWorkspaceController.text);
        workspaceController.createNewWorkspace(fieldWorkspaceController.text);
      },
    );
  }

  // Conteúdo de meia largura para layout horizontal
  Widget _content() {
    return Container(
        width: (MediaQuery.of(context).size.width / 2) - 1,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(children: [
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SetupTitle(title: strTitle))
            ]),
            _workspaceWays(),
          ],
        )));
  }

  // Conteúdo em caixa para layout vertical
  Widget _contentBox() {
    return Container(
        height: (MediaQuery.of(context).size.height / 2) - 100,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(children: [
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SetupTitle(title: strTitle))
            ]),
            Padding(
              child: SetupText(text: strTextlocated),
              padding: EdgeInsets.all(12),
            ),
            _workspaceWays(),
          ],
        )));
  }

  Widget _workspaceWays() {
    return GetX<WorkspaceController>(builder: (ix) {
      debugPrint(
          'f8870 - workspaceList size: ${ix.workspacesList.length.toString()}');

      //---- Workspace list is ok, save it
      if (ix.workspacesList.length > 0) {
        workspaceController.saveWorkspaces();
      } else {
        return Center(
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              //debugPrint('Error: {$snapshot.error}'),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SetupText(text: strTextNew),
              ),
              _getWorkspaceName(),
              _createWorkspaceBtn(),
            ],
          ),
        );
      }

      return Container(
          height: MediaQuery.of(context).size.height - 200,
          child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: ix.workspacesList.length,
              itemBuilder: (BuildContext context, int index) {
                if (ix.workspacesList[index] == null) {
                  return Container();
                } else {
                  return ListTile(
                    title: Text(ix.workspacesList[index].name),
                    leading: const Icon(Icons.check_circle),
                    subtitle: Text(ix.workspacesList[index].domain,
                        style: TextStyle(fontSize: 12)),
                    onTap: () {},
                    onLongPress: () {},
                  );
                }
              })));
    });

    return GetX<WorkspaceController>(builder: (ix) {
      debugPrint(
          'f8870 - workspaceList size: ${ix.workspacesList.length.toString()}');
      return Obx(() => ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: ix.workspacesList.length,
          itemBuilder: (BuildContext context, int index) {
            if (ix.workspacesList[index] == null) {
              return Container();
            } else {
              return ListTile(
                selected: ix.workspacesList[index].isSelected,
                title: Text(ix.workspacesList[index].key),
                leading: ix.workspacesList[index].isSelected
                    ? const Icon(Icons.check_circle)
                    : const Icon(Icons.circle_outlined),
                subtitle: Text(ix.workspacesList[index].content,
                    style: TextStyle(fontSize: 12)),
                onTap: () {},
                onLongPress: () {},
              );
            }
          }));
    });

    /*


    return FutureBuilder(
        future: workspaceController.workspacesList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            debugPrint('Carregando informações...');
            return Center(
              child: Column(children: [
                CircularProgressIndicator(),
                /*MaterialButton(
                    child: Text('Exibir workspaces variable'),
                    onPressed: () async {
                      debugPrint(_workspaces.toString());
                      /*
                      var i = 0;
                      WorkspaceModel thwks = snapshot.data[i];
                      debugPrint(thwks.name);
                      */
                      (await _workspaces).forEach((item) {
                        debugPrint('item');
                      });
                    })*/
              ]),
            );
          } else if (snapshot.hasError) {
            debugPrint('uM ERRO...');
            return Container();
          } else if (snapshot.hasData) {
            // Empty data, this is to put new workspace name
            if (snapshot.data.length <= 0) {
              return Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Text('Error: {$snapshot.error}'),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SetupText(text: strTextNew),
                    ),
                    _getWorkspaceName(),
                    _createWorkspaceBtn(),
                  ],
                ),
              );
            } else {
              debugPrint('OK OK OK \$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$...');
              debugPrint('Getting data from repository into FutureBuilder...');
              // Save Local workspaces (keys) and important data
              WorkspaceUtils().saveCfgWorkspace(snapshot.data);

              return SingleChildScrollView(
                  child: Column(children: [
                Padding(
                  child: SetupText(text: strTextlocated),
                  padding: EdgeInsets.all(12),
                ),
                Container(
                    width: 200,
                    height: 400,
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          WorkspaceModel item = snapshot.data[index];
                          return Card(
                              child: ListTile(
                            trailing: Icon(Icons.check),
                            title: Text(item.name),
                            subtitle: Text(item.domain == 'personal'
                                ? 'Workspace Pessoal'
                                : 'Workspace'),
                            tileColor: item.domain == 'personal'
                                ? Colors.greenAccent
                                : null,
                            onTap: () {},
                          ));
                        })),
              ]));
            }
          } else {
            debugPrint('??????????????????????????' +
                'Getting data from repository into FutureBuilder (what\'s data)...');
            return Container();
          }
        });
    */
  }

  Widget _getWorkspaceName() {
    return Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    style: TextStyle(fontSize: 24),
                    controller: fieldWorkspaceController,
                    decoration: InputDecoration(
                        labelText: '',
                        hintText: 'workspace',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Insira seu workspace';
                      } else {
                        _theInputWorkspace = value;
                        return value;
                      }
                    }),
              ),
            ]));
  }

  // Seletor de layout conforme largura
  Widget _layout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _layoutViewSmall();
        } else {
          return _layoutViewLarge();
        }
      },
    );
  }

  // Em largura menor empilamento dos widgets
  // (um abaixo do outro)
  Widget _layoutViewSmall() {
    return Container(child: Column(children: [_imageBox(), _contentBox()]));
  }

  // Em largura maior coloca os widgets em row
  // (um ao lado do outro)
  Widget _layoutViewLarge() {
    return Container(
        child: Column(children: [
      Row(children: [_image(), _content()])
    ]));
  }
}
