import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/calendar_type_provider.dart';
import '../../providers/date_provider.dart';
import '../../widgets/calendar_button.dart';
import '../../models/calendar_type.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';
import '../../util/date_util.dart';
import 'table_helper.dart';

class CalendarNavigationBar extends StatefulWidget {
  const CalendarNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarNavigationBar> createState() => _CalendarNavigationBarState();
}

class _CalendarNavigationBarState extends State<CalendarNavigationBar> {
  List<bool> _isSelected = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DateProvider>(context);
    final todayButtonPressedHandler = _createTodayButtonPressedHandler();
    _initIsSelected();
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CalendarButton(
            padding: navigateButtonPadding,
            borderRadius: leftRoundBorderRadius,
            child: const Icon(Icons.navigate_before),
            onPressed: _handlePrevSelect,
          ),
          const SizedBox(width: AppSizes.spacingXxs),
          CalendarButton(
            padding: navigateButtonPadding,
            borderRadius: rightRoundBorderRadius,
            child: const Icon(Icons.navigate_next),
            onPressed: _handleNextSelect,
          ),
          const SizedBox(width: AppSizes.spacingL),
          CalendarButton(
            child: const Text('today'),
            onPressed: todayButtonPressedHandler,
          ),
          Expanded(
            child: Text(
              TableHelper.instance.getNavigationTitle(
                context,
                provider.selectedDate,
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 36,
            child: ToggleButtons(
              borderRadius: const BorderRadius.all(
                Radius.circular(AppSizes.spacingS),
              ),
              color: AppColors.blue,
              selectedColor: Colors.white,
              fillColor: AppColors.blue,
              children: const [
                Text('week'),
                Text('day'),
              ],
              onPressed: _handleToggleButtonsPress,
              isSelected: _isSelected,
            ),
          ),
        ],
      ),
    );
  }

  _initIsSelected() {
    final provider = Provider.of<CalendarTypeProvider>(context);
    _isSelected = [
      provider.type == CalendarType.week,
      provider.type == CalendarType.day,
    ];
  }

  _handleToggleButtonsPress(int index) {
    final provider = Provider.of<CalendarTypeProvider>(context, listen: false);
    provider.type = _getCalendarType(index);
  }

  CalendarType _getCalendarType(int index) {
    switch (index) {
      case 0:
        return CalendarType.week;
      default:
        return CalendarType.day;
    }
  }

  _handlePrevSelect() {
    final provider = Provider.of<DateProvider>(context, listen: false);
    if (_isWeekCalendarType()) {
      provider.selectPrevWeek();
    } else {
      provider.selectPrevDay();
    }
  }

  _handleNextSelect() {
    final provider = Provider.of<DateProvider>(context, listen: false);
    if (_isWeekCalendarType()) {
      provider.selectNextWeek();
    } else {
      provider.selectNextDay();
    }
  }

  VoidCallback? _createTodayButtonPressedHandler() {
    final provider = Provider.of<DateProvider>(context, listen: false);
    final selectedDate = provider.selectedDate;
    if (_isWeekCalendarType()) {
      return DateUtil.isCurrentWeek(selectedDate) ? null : () => provider.reset();
    } else {
      return DateUtil.isToday(selectedDate) ? null : () => provider.reset();
    }
  }

  _isWeekCalendarType() {
    final provider = Provider.of<CalendarTypeProvider>(context, listen: false);
    return provider.type == CalendarType.week;
  }
}

const navigateButtonPadding = EdgeInsets.symmetric(
  horizontal: AppSizes.buttonVerticalPadding,
  vertical: AppSizes.buttonVerticalPadding,
);
const leftRoundBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(AppSizes.spacingS),
  bottomLeft: Radius.circular(AppSizes.spacingS),
);
const rightRoundBorderRadius = BorderRadius.only(
  topRight: Radius.circular(AppSizes.spacingS),
  bottomRight: Radius.circular(AppSizes.spacingS),
);
