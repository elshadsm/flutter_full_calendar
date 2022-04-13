import 'package:flutter/material.dart';
import 'package:flutter_full_calendar/util/date_util.dart';
import 'package:flutter_full_calendar/widgets/horizontal_table_separators.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/date_provider.dart';
import '../../resources/sizes.dart';
import 'week_table_header_cell.dart';

class WeekTableHeader extends StatelessWidget {
  const WeekTableHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DateProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.weekTableHourCellWidth,
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _createCells(provider),
          ),
          const Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: HorizontalTableSeparators(
                cellCount: DateTime.daysPerWeek,
                cellHeight: AppSizes.weekTableHeaderSeparator,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createCells(DateProvider provider) {
    List<Widget> cells = [];
    final selectedDate = provider.selectedDate;
    final startOfTheWeek = DateUtil.getStartOfTheWeek(selectedDate);
    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      final weekDayDate = startOfTheWeek.add(Duration(days: i));
      final day = startOfTheWeek.day + i;
      cells.add(
        WeekTableHeaderCell(
          week: DateFormat.E().format(weekDayDate).toUpperCase(),
          day: day,
          isToday: provider.isTodayInSelectedWeek(day),
        ),
      );
    }
    return cells;
  }
}
