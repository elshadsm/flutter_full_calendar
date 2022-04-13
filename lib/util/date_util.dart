import 'package:jiffy/jiffy.dart';

class DateUtil {
  static const int hoursPerDay = 24;
  static const int minutesPerHour = 60;

  static DateTime getStartOfTheWeek(DateTime date) =>
      Jiffy(date).startOf(Units.WEEK).dateTime.add(
            const Duration(days: 1),
          );

  static DateTime getEndOfTheWeek(DateTime date) =>
      Jiffy(date).endOf(Units.WEEK).dateTime.add(
            const Duration(days: 1),
          );

  static DateTime getStartOfDay(DateTime date) =>
      Jiffy(date).startOf(Units.DAY).dateTime;

  static DateTime getEndOfDay(DateTime date) =>
      Jiffy(date).endOf(Units.DAY).dateTime;
}
