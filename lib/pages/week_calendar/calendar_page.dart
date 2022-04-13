import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/date_provider.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';
import 'calendar_navigation_bar.dart';
import 'week_table_hours_column.dart';
import 'week_table_header.dart';
import 'week_table.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<DateProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Calendar Component'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacingL,
          horizontal: 128,
        ),
        color: AppColors.lightGrey,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: AppSizes.spacingS,
                color: AppColors.darkYellow,
              ),
              const CalendarNavigationBar(),
              const Divider(
                color: AppColors.dividerBackground,
                height: AppSizes.dividerSize,
                thickness: AppSizes.dividerSize,
              ),
              const SizedBox(height: AppSizes.spacingL),
              const WeekTableHeader(),
              Expanded(
                child: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
