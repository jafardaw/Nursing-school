
extension DateTimeExtensions on DateTime {
  String get formattedDate {
    return '${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year';
  }

  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }

  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return day == yesterday.day &&
        month == yesterday.month &&
        year == yesterday.year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return day == tomorrow.day &&
        month == tomorrow.month &&
        year == tomorrow.year;
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  DateTime get startOfWeek {
    final startOfWeek = subtract(Duration(days: weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  DateTime get endOfWeek {
    final endOfWeek = add(Duration(days: DateTime.daysPerWeek - weekday));
    return DateTime(
      endOfWeek.year,
      endOfWeek.month,
      endOfWeek.day,
      23,
      59,
      59,
      999,
    );
  }

  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  DateTime get endOfMonth {
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, lastDay, 23, 59, 59, 999);
  }

  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }

  DateTime get endOfYear {
    return DateTime(year, 12, 31, 23, 59, 59, 999);
  }

  bool isSameDay(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  bool isSameMonth(DateTime other) {
    return month == other.month && year == other.year;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  DateTime addMonths(int months) {
    return DateTime(
      year + (month + months - 1) ~/ 12,
      (month + months - 1) % 12 + 1,
      day,
    );
  }

  DateTime subtractMonths(int months) {
    return addMonths(-months);
  }

  DateTime addYears(int years) {
    return DateTime(year + years, month, day);
  }

  DateTime subtractYears(int years) {
    return DateTime(year - years, month, day);
  }
}
