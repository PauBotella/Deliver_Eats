import 'package:intl/intl.dart';

formatNumber(double number) {
  return NumberFormat("#,#0.0", "es_ES").format(number);
}
