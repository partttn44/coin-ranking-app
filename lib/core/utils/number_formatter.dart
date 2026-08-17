import 'package:intl/intl.dart';

String formatMarketCap(num value) {
  final absoluteValue = value.abs();

  if (absoluteValue >= 1_000_000_000_000) {
    return '${(value / 1_000_000_000_000).toStringAsFixed(2)} Trillion';
  }
  if (absoluteValue >= 1_000_000_000) {
    return '${(value / 1_000_000_000).toStringAsFixed(2)} Billion';
  }
  if (absoluteValue >= 1_000_000) {
    return '${(value / 1_000_000).toStringAsFixed(2)} Million';
  }

  return NumberFormat.decimalPattern('en_US').format(value);
}

String formatCurrency(num value, {int decimalDigits = 2}) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
    decimalDigits: decimalDigits,
  ).format(value).trim();
}
