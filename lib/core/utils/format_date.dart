import 'package:intl/intl.dart';

String formatDateBydMMMYYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime);
}

String getTodaysDate() {
  final now = DateTime.now();
  final day = now.day;
  final month = _monthAbbreviation(now.month);
  return '$day $month';
}

String _monthAbbreviation(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}