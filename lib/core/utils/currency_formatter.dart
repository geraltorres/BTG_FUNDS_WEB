import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String getCurrencyFormated(dynamic number) {
    final currency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: 'COP ',
      decimalDigits: 0,
    );
    return currency.format(number);
  }
}
