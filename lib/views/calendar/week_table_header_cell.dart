import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/calendar_type_provider.dart';
import '../../providers/date_provider.dart';
import '../../models/calendar_type.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class WeekTableHeaderCell extends StatelessWidget {
  final DateTime weekDayDate;

  const WeekTableHeaderCell({
    Key? key,
    required this.weekDayDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DateProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    final day = weekDayDate.day;
    final isToday = provider.isTodayInSelectedWeek(day);
    return Expanded(
      child: Column(
        children: [
          Text(
            DateFormat.E().format(weekDayDate).toUpperCase(),
            style: textTheme.caption?.copyWith(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.spacing),
          TextButton(
            child: Text(
              day.toString(),
              style: textTheme.headline5?.copyWith(
                color: isToday ? Colors.white : AppColors.blue,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(AppSizes.spacingL),
              backgroundColor: isToday ? AppColors.blue : null,
              shape: const CircleBorder(),
            ),
            onPressed: () => _handleButtonSelect(context),
          ),
          const SizedBox(height: AppSizes.spacingS),
        ],
      ),
    );
  }

  _handleButtonSelect(BuildContext context) {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final calendarTypeProvider =
        Provider.of<CalendarTypeProvider>(context, listen: false);
    dateProvider.selectedDate = weekDayDate;
    calendarTypeProvider.type = CalendarType.day;
  }
}
