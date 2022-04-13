import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/date_provider.dart';
import '../models/week_graph_color.dart';
import '../models/week_graph_size.dart';
import '../models/event_type.dart';
import '../resources/colors.dart';
import '../resources/sizes.dart';
import '../util/date_util.dart';
import '../models/event.dart';

class WeekGraphUtil {
  WeekGraphUtil._privateConstructor();

  static final instance = WeekGraphUtil._privateConstructor();

  WeekGraphSize calculateSize({
    required BuildContext context,
    required Event event,
    required int weekDay,
    required double cellWidth,
  }) {
    final provider = Provider.of<DateProvider>(context, listen: false);
    final selectedDate = provider.selectedDate;
    final weekDayDate = DateUtil.getStartOfTheWeek(selectedDate).add(
      Duration(days: weekDay - 1),
    );
    final top = _calculateTop(event, weekDayDate);
    return WeekGraphSize(
      left: _calculateLeft(event, cellWidth, weekDayDate),
      top: top,
      width: _calculateWidth(cellWidth),
      height: _calculateHeight(event, weekDayDate, top),
    );
  }

  WeekGraphColor getColor(Event event) {
    switch (event.type) {
      case EventType.a:
        return WeekGraphColor(
          background: AppColors.lightRed,
          text: AppColors.darkRed,
          border: AppColors.red,
        );
      case EventType.b:
        return WeekGraphColor(
          background: AppColors.lightGreen,
          text: AppColors.darkGreen,
          border: AppColors.green,
        );
      case EventType.c:
        return WeekGraphColor(
          background: AppColors.lightBlue,
          text: AppColors.darkBlue,
          border: AppColors.blue,
        );
      case EventType.d:
        return WeekGraphColor(
          background: AppColors.lightPurple,
          text: AppColors.darkPurple,
          border: AppColors.purple,
        );
      case EventType.e:
        return WeekGraphColor(
          background: AppColors.lightYellow,
          text: AppColors.darkYellow,
          border: AppColors.yellow,
        );
      case EventType.f:
        return WeekGraphColor(
          background: AppColors.lightCyan,
          text: AppColors.darkCyan,
          border: AppColors.cyan,
        );
      default:
        return WeekGraphColor(
          background: AppColors.lightRed,
          text: AppColors.darkRed,
          border: AppColors.red,
        );
    }
  }

  double _calculateLeft(
    Event event,
    double cellWidth,
    DateTime weekDayDate,
  ) {
    final margin = _calculateLeftMargin(event, cellWidth);
    return (weekDayDate.weekday - 1) * cellWidth + margin;
  }

  double _calculateTop(
    Event event,
    DateTime weekDayDate,
  ) {
    final startOfWeekDay = DateUtil.getStartOfDay(weekDayDate);
    final rate = event.from.isBefore(startOfWeekDay)
        ? 0
        : (event.from.hour + event.from.minute / DateUtil.minutesPerHour);
    return rate * AppSizes.weekTableCellHeight;
  }

  double _calculateWidth(double cellWidth) {
    return cellWidth / 2 - AppSizes.spacingS;
  }

  double _calculateHeight(
    Event event,
    DateTime weekDayDate,
    double top,
  ) {
    final endOfWeekDay = DateUtil.getEndOfDay(weekDayDate);
    final rate = event.to.isAfter(endOfWeekDay)
        ? DateUtil.hoursPerDay
        : (event.to.hour + event.to.minute / DateUtil.minutesPerHour);
    final bottom = rate * AppSizes.weekTableCellHeight;
    return bottom - top;
  }

  double _calculateLeftMargin(
    Event event,
    double cellWidth,
  ) {
    final half = cellWidth / 2;
    final margin = half / 5;
    switch (event.type) {
      case EventType.a:
        return 0;
      case EventType.b:
        return margin;
      case EventType.c:
        return 2 * margin;
      case EventType.d:
        return 3 * margin + AppSizes.spacingS;
      case EventType.e:
        return 4 * margin + AppSizes.spacingS;
      case EventType.f:
        return 5 * margin + AppSizes.spacingS;
      default:
        return 0;
    }
  }
}
