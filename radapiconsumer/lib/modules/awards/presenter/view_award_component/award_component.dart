import '../../../../core/enums/enum_awards.dart';
import '../../../../routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AwardComponent extends StatelessWidget {
  EIAwardsNotifications notification;
  int qty;

  AwardComponent({
    Key? key,
    required this.notification,
    required this.qty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.notifications);
      },
      child: (this.notification == EIAwardsNotifications.notifyNotEmpty)
          ? Stack(children: [
              Container(
                  width: 38,
                  child: Icon(
                    this.qty <= 0 ? Icons.emoji_events : Icons.emoji_events,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 32.0,
                  )),
              this.qty <= 0
                  ? Container()
                  : Positioned(
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          qty.toString(),
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ])
          : Container(
              child: Icon(
                Icons.emoji_events,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 30.0,
              ),
            ),
    );
  }
}
