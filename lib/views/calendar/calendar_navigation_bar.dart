import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/date_provider.dart';
import '../../widgets/calendar_button.dart';
import '../../models/calendar_type.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class CalendarNavigationBar extends StatefulWidget {
  final void Function(CalendarType calendarType) onCalendarSelect;

  const CalendarNavigationBar({
    Key? key,
    required this.onCalendarSelect,
  }) : super(key: key);

  @override
  State<CalendarNavigationBar> createState() => _CalendarNavigationBarState();
}

class _CalendarNavigationBarState extends State<CalendarNavigationBar> {
  final List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DateProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CalendarButton(
            padding: navigateButtonPadding,
            borderRadius: leftRoundBorderRadius,
            child: const Icon(Icons.navigate_before),
            onPressed: () => provider.selectPrevWeek(),
          ),
          const SizedBox(width: AppSizes.spacingXxs),
          CalendarButton(
            padding: navigateButtonPadding,
            borderRadius: rightRoundBorderRadius,
            child: const Icon(Icons.navigate_next),
            onPressed: () => provider.selectNextWeek(),
          ),
          const SizedBox(width: AppSizes.spacingL),
          CalendarButton(
            child: const Text('today'),
            onPressed:
                provider.isSelectedWeekNow ? null : () => provider.reset(),
          ),
          Expanded(
            child: Text(
              DateFormat.yMMMM().format(provider.selectedDate),
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
              isSelected: isSelected,
            ),
          ),
        ],
      ),
    );
  }

  _handleToggleButtonsPress(int index) {
    _updateIsSelected(index);
    widget.onCalendarSelect(_getCalendarType(index));
  }

  _updateIsSelected(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < isSelected.length;
          buttonIndex++) {
        if (buttonIndex == index) {
          isSelected[buttonIndex] = true;
        } else {
          isSelected[buttonIndex] = false;
        }
      }
    });
  }

  CalendarType _getCalendarType(int index) {
    switch (index) {
      case 0:
        return CalendarType.week;
      default:
        return CalendarType.day;
    }
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
