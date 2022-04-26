import 'package:intl/intl.dart';

import '../models/event_graph_color.dart';
import '../models/event_graph_size.dart';
import '../models/event_type.dart';
import '../resources/colors.dart';
import '../resources/sizes.dart';
import '../util/date_util.dart';
import '../models/event.dart';

const rightPadding = AppSizes.spacing;

class EventGraphUtil {
  EventGraphUtil._privateConstructor();

  static final instance = EventGraphUtil._privateConstructor();

  EventGraphSize calculateSizeForWeekCalendar({
    required Event event,
    required DateTime date,
    required int weekDay,
    required double cellWidth,
  }) {
    final weekDayDate = DateUtil.getStartOfTheWeek(date).add(
      Duration(days: weekDay - 1),
    );
    final continueFromPrevDay = _checkContinueFromPrevDay(event, weekDayDate);
    final continueToNextDay = _checkContinueToNextDay(event, weekDayDate);
    final graphWidth = _calculateWeekWidth(event, cellWidth);
    final top = _calculateTop(event, continueFromPrevDay);
    final bottom = _calculateBottom(event, continueToNextDay);
    return EventGraphSize(
      left: _calculateWeekLeft(event, cellWidth, graphWidth, weekDayDate),
      top: top,
      width: graphWidth,
      height: bottom - top,
      continueFromPrevDay: continueFromPrevDay,
      continueToNextDay: continueToNextDay,
    );
  }

  EventGraphSize calculateSizeForDayCalendar({
    required Event event,
    required DateTime date,
    required double cellWidth,
  }) {
    final continueFromPrevDay = _checkContinueFromPrevDay(event, date);
    final continueToNextDay = _checkContinueToNextDay(event, date);
    final top = _calculateTop(event, continueFromPrevDay);
    final bottom = _calculateBottom(event, continueToNextDay);
    return EventGraphSize(
      left: _calculateDayLeft(event, cellWidth),
      top: top,
      width: _getAbsoluteWidth(cellWidth),
      height: bottom - top,
      continueFromPrevDay: continueFromPrevDay,
      continueToNextDay: continueToNextDay,
    );
  }

  EventGraphColor getColor(Event event) {
    switch (event.type) {
      case EventType.a:
        return EventGraphColor(
          background: AppColors.lightBlue,
          text: AppColors.darkBlue,
          border: AppColors.blue,
        );
      case EventType.b:
        return EventGraphColor(
          background: AppColors.lightGreen,
          text: AppColors.darkGreen,
          border: AppColors.green,
        );
      case EventType.c:
        return EventGraphColor(
          background: AppColors.lightRed,
          text: AppColors.darkRed,
          border: AppColors.red,
        );
      case EventType.d:
        return EventGraphColor(
          background: AppColors.lightPurple,
          text: AppColors.darkPurple,
          border: AppColors.purple,
        );
      case EventType.e:
        return EventGraphColor(
          background: AppColors.lightYellow,
          text: AppColors.darkYellow,
          border: AppColors.yellow,
        );
      case EventType.f:
        return EventGraphColor(
          background: AppColors.lightCyan,
          text: AppColors.darkCyan,
          border: AppColors.cyan,
        );
      default:
        return EventGraphColor(
          background: AppColors.lightRed,
          text: AppColors.darkRed,
          border: AppColors.red,
        );
    }
  }

  getHourText(Event event) {
    final dateFormat = DateFormat.Hm();
    return '${dateFormat.format(event.from)} - ${dateFormat.format(event.to)}';
  }

  bool _checkContinueFromPrevDay(
    Event event,
    DateTime date,
  ) {
    final startOfWeekDay = DateUtil.getStartOfDay(date);
    return event.from.isBefore(startOfWeekDay);
  }

  bool _checkContinueToNextDay(
    Event event,
    DateTime date,
  ) {
    final endOfWeekDay = DateUtil.getEndOfDay(date);
    return event.to.isAfter(endOfWeekDay);
  }

  double _calculateWeekLeft(
    Event event,
    double cellWidth,
    double graphWidth,
    DateTime weekDayDate,
  ) {
    final margin = _calculateLeftMargin(event, cellWidth, graphWidth);
    return (weekDayDate.weekday - 1) * cellWidth + margin;
  }

  double _calculateDayLeft(
    Event event,
    double cellWidth,
  ) {
    return (event.type.index) * cellWidth;
  }

  double _calculateTop(
    Event event,
    bool continueFromPrevDay,
  ) {
    final rate = continueFromPrevDay
        ? 0
        : (event.from.hour + event.from.minute / DateUtil.minutesPerHour);
    return rate * AppSizes.tableCellHeight;
  }

  double _calculateWeekWidth(Event event, double cellWidth) {
    if (event.constraints.relationCount == 0) {
      return _getAbsoluteWidth(cellWidth);
    }
    if (event.constraints.relationCount == 2) {
      return _getAbsoluteWidth(cellWidth) / 3;
    }
    return _getAbsoluteWidth(cellWidth) / 2;
  }

  double _calculateBottom(
    Event event,
    bool continueToNextDay,
  ) {
    final rate = continueToNextDay
        ? DateUtil.hoursPerDay
        : (event.to.hour + event.to.minute / DateUtil.minutesPerHour);
    return rate * AppSizes.tableCellHeight;
  }

  double _calculateLeftMargin(
    Event event,
    double cellWidth,
    double graphWidth,
  ) {
    if (event.constraints.relationCount < 3) {
      return event.constraints.horizontalIndex * graphWidth;
    } else {
      final half = _getAbsoluteWidth(cellWidth) / 2;
      final margin = half / event.constraints.relationCount;
      return event.constraints.horizontalIndex * margin;
    }
  }

  double _getAbsoluteWidth(double cellWidth) => cellWidth - rightPadding;
}
