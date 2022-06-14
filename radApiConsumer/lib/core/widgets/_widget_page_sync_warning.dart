import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetPageSyncWarning extends StatelessWidget {
  String title;
  GestureTapCallback onTap;
  WidgetPageSyncWarning({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.refresh, color: Colors.black),
              Text(
                'Sincronização : Toque aqui para enviar',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
              )
            ],
          ),
        ),
      ),
    );
  }
}
