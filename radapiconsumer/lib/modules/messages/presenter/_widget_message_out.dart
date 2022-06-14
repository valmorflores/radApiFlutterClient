import 'package:flutter/material.dart';

import '/modules/messages/infra/models/message_conversation_model.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageOut extends StatelessWidget {
  final MessageConversationModel item;
  final int index;

  const MessageOut({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _marginMe = MediaQuery.of(context).size.width * 0.10;
    if (item.message!.length < 25) {
      _marginMe = MediaQuery.of(context).size.width * 0.50;
    }
    //
    double _widthArea = (MediaQuery.of(context).size.width > 1024)
        ? (MediaQuery.of(context).size.width / 3) * 2
        : MediaQuery.of(context).size.width;
    double _sizeForText = item.message!.length < 10
        ? item.message!.length * 40
        : (item.message!.length * 12.00);
    if (_sizeForText > _widthArea) {
      _sizeForText = _widthArea * .70;
    }

    if (_sizeForText < 160) {
      _sizeForText = 160;
    }

    String _date = '';
    if (item.timeCreated != null) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(item.timeCreated! * 1000);
      _date = DateFormat('dd/MM/yyyy, HH:mm').format(date);
    }

    return Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        child: Row(
          children: [
            const Spacer(),
            Container(
              width: _sizeForText,
              child: ListTile(
                title: Container(
                  decoration: BoxDecoration(
                      color: _colorBackground(context),
                      border: Border.all(
                        color: _colorBackground(context),
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16))),
                  child: _text(item.message!, context),
                ),
                //trailing: const Icon(Icons.check),
                subtitle: Row(children: [
                  const Spacer(),
                  Text('${item.id} ${_date}', style: TextStyle(fontSize: 10))
                ]),
              ),
            ),
          ],
        ));
  }

  _colorBackground(context) {
    return Theme.of(context).colorScheme.secondaryVariant;
  }

  _text(_text, context) {
    if (_text.contains('http') || _text.contains('<br>')) {
      return Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 0, 0), child: Text(_text));
      //fontSize: FontSize(18.0),
      //fontWeight: FontWeight.bold,

    } else {
      return Padding(
          padding: EdgeInsets.all(18),
          child: SelectableText('${item.message}', style: _fontStyleOut()));
    }
  }

  _fontStyleOut() {
    return GoogleFonts.ubuntu(
            //backgroundColor: Theme.of(context).colorScheme.secondary,
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 16)
        .copyWith();
  }
}
