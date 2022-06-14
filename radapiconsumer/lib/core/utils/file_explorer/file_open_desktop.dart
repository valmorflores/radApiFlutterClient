import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileOpenDesktop extends StatefulWidget {
  List<String> _selection = [];
  bool _multipleFiles = false;

  bool _isAllowedFileTypesInputVisible = false;
  TextEditingController _allowedFileTypesController = TextEditingController();

  @override
  initState() {
    this._pickFile();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  Future<void> _pickFile() async {
    final allowedFileTypes = this
        ._allowedFileTypesController
        .text
        .split(',')
        .map((fileType) => fileType.trim())
        .toList();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File('${result.files.single.path}');
      } else {
        // User canceled the picker
      }

      /*final FilePickerResult result = await pickFiles(
        allowMultiple: this._multipleFiles,
        allowedExtensions:
            this._fileType == FileType.custom ? allowedFileTypes : null,
        type: this._fileType,
      );*/

      if (result != null) {
        this._selection = result.files.map((e) => e.path ?? 'ERROR').toList();
      } else {
        this._selection = [];
      }
    } catch (e) {
      this._selection = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arquivos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, _selection),
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            const Divider(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  'Selecionado:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            IntrinsicWidth(
              child: Container(
                height: 400,
                child: _selection.isEmpty
                    ? const Text('Nothing selected')
                    : ListView.builder(
                        itemCount: _selection.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ListTile(
                          title: Text(_selection[index]),
                          leading: const Icon(Icons.folder),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
