import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  static Future<String> readTimestamp(int timestamp) async {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    return initializeDateFormatting('pt_BR', null).then((_) {
      if (diff.inSeconds <= 0 ||
          diff.inSeconds > 0 && diff.inMinutes == 0 ||
          diff.inMinutes > 0 && diff.inHours == 0 ||
          diff.inHours > 0 && diff.inDays == 0) {
        var format = DateFormat.Hm();
        time = 'Hoje às ' + format.format(date);
      } else if (diff.inDays > 0 && diff.inDays < 7) {
        if (diff.inDays == 1) {
          time = diff.inDays.toString() + ' dia atrás';
        } else {
          time = diff.inDays.toString() + ' dias atrás';
        }
      } else {
        if (diff.inDays == 7) {
          time = (diff.inDays / 7).floor().toString() + ' semana atrás';
        } else {
          time = (diff.inDays / 7).floor().toString() + ' semanas atrás';
        }
      }
      return time;
    });
  }
}
