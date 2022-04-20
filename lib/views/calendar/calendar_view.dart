import 'package:flutter/material.dart';

import '../../models/calendar_type.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';
import 'calendar_navigation_bar.dart';
import 'week_table_hours_column.dart';
import 'week_table_header.dart';
import 'week_table.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final ScrollController _scrollController;

  CalendarType _calendarType = CalendarType.week;
  var _scrolled = false;

  @override
  void initState() {
    super.initState();
    _initScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: AppSizes.spacingS,
            thickness: AppSizes.spacingS,
            color: AppColors.darkYellow,
          ),
          CalendarNavigationBar(
            onCalendarSelect: (CalendarType type) =>
                setState(() => _calendarType = type),
          ),
          const Divider(
            color: AppColors.dividerBackground,
            height: AppSizes.dividerSize,
            thickness: AppSizes.dividerSize,
          ),
          const SizedBox(height: AppSizes.spacingL),
          WeekTableHeader(
            showBottomBorder: _scrolled,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  WeekTableHoursColumn(),
                  Expanded(
                    child: WeekTable(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _initScrollController() {
    _scrollController = ScrollController()
      ..addListener(() {
        final scrolled = _scrollController.offset > 0;
        if (_scrolled != scrolled) {
          setState(() => _scrolled = scrolled);
        }
      });
  }
}
