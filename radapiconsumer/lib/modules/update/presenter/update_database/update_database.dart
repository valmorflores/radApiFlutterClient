import '/modules/update/presenter/controllers/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateDatabaseServer extends StatefulWidget {
  const UpdateDatabaseServer({Key? key}) : super(key: key);

  @override
  _UpdateDatabaseServerState createState() => _UpdateDatabaseServerState();
}

class _UpdateDatabaseServerState extends State<UpdateDatabaseServer> {
  UpdateController _updateController = Get.put(UpdateController());

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(title: Text('')),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(child: Container())),
            const Spacer(),
            Container(
                width: 200,
                child:
                    Image.asset('assets/images/dialog/new_message_pict.png')),
            Text('Atualização de dados', style: TextStyle(fontSize: 26)),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                  'Esta ferramenta é responsável por acionar atualização do banco de dados relativo ao workspace atual. Isso é necessário sempre que o sistema tiver uma mudança significativa de versão.'),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    await _updateController.runUpdate();
                    Get.snackbar('Atualização executada',
                        'Rotina de atualização executada com sucesso');
                  },
                  child: Text('ATUALIZAR'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('FECHAR'),
                ),
                const Spacer(),
              ],
            ),
            const Spacer(),
          ],
        )));
  }
}
