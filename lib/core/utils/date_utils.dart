class TaskDateUtils {
  const TaskDateUtils._();

  static bool isOverdue(DateTime deadline, {DateTime? now}) {
    return (now ?? DateTime.now()).isAfter(deadline);
  }

  static Duration remainingTime(DateTime deadline, {DateTime? now}) {
    final remaining = deadline.difference(now ?? DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  static Duration overdueDuration(DateTime deadline, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    if (!currentTime.isAfter(deadline)) return Duration.zero;
    return currentTime.difference(deadline);
  }

  static bool isSameCalendarDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static int calendarDayOffset(DateTime deadline, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    final today = DateTime(currentTime.year, currentTime.month, currentTime.day);
    final dueDate = DateTime(deadline.year, deadline.month, deadline.day);
    return dueDate.difference(today).inDays;
  }

  static String formatCountdown(DateTime deadline, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    if (isOverdue(deadline, now: currentTime)) {
      return formatOverdueDuration(
        overdueDuration(deadline, now: currentTime),
      );
    }

    final remaining = remainingTime(deadline, now: currentTime);
    if (remaining.inDays > 0) return '${remaining.inDays} days left';
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h '
        '${minutes.toString().padLeft(2, '0')}m left';
  }

  static String formatOverdueDuration(Duration duration) {
    if (duration.inDays > 0) {
      final days = duration.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} overdue';
    }
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} overdue';
    }
    final minutes = duration.inMinutes < 1 ? 1 : duration.inMinutes;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} overdue';
  }
}