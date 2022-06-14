import '../../../core/constants/kglobal.dart';
import 'package:intl/intl.dart';

class NumberUtil {
  final formatter = NumberFormat("#,##0.00", "pt_BR");

  format(double value) {
    String newText = kmoneySymbol + ' ' + formatter.format(value);
    return newText;
  }

  formatPercent(double value) {
    String newText = formatter.format(value) + '%';
    return newText;
  }
}
