import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final DateFormat _date = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final NumberFormat _amount = NumberFormat('#,##,##0.00', 'en_IN');

  static String date(DateTime value) => _date.format(value);

  static String dateTime(DateTime value) => _dateTime.format(value);

  static String amount(num value, {String symbol = '₹'}) =>
      '$symbol ${_amount.format(value)}';
}
