/// utils/date_formatter.dart
class DateFormatter {
  /// Format the date
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
