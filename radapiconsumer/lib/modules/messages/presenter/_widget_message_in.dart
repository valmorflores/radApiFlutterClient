import 'package:flutter/material.dart';
import '/modules/messages/infra/models/message_conversation_model.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageIn extends StatelessWidget {
  MessageConversationModel item;
  int index;

  MessageIn({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _marginShe = MediaQuery.of(context).size.width * 0.10;
    if (item.message!.length < 25) {
      _marginShe = MediaQuery.of(context).size.width * 0.50;
    }
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          0,
          _marginShe,
          0,
        ),
        child: ListTile(
          title: Container(
            decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border.all(
                  color: Colors.grey[900]!,
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16))),
            child: _text(item.message, context),
          ),
          //subtitle: Text(item.memberId.toString()),
        ),
      ),
    );
  }

  _text(_text, context) {
    if (_text.contains('http') ||
        _text.contains('<br>') ||
        _text.contains('&')) {
      return Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 0, 0), child: Text(_text));
    } else {
      return Padding(
          padding: EdgeInsets.all(18),
          child: SelectableText('${item.message}', style: _fontStyle()));
    }
  }

  _fontStyle() {
    return GoogleFonts.ubuntu(
            //backgroundColor: Colors.grey[900],
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 16)
        .copyWith();
  }
}
