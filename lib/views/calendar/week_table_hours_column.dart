import 'package:flutter/material.dart';

import '../../widgets/vertical_table_separators.dart';
import '../../resources/sizes.dart';
import '../../util/date_util.dart';

class WeekTableHoursColumn extends StatelessWidget {
  const WeekTableHoursColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: AppSizes.weekTableCellHeight / 2),
            ..._createCells(context),
            const SizedBox(height: AppSizes.weekTableCellHeight / 2),
          ],
        ),
        const Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: VerticalTableSeparators(
              cellCount: DateUtil.hoursPerDay,
              cellWidth: AppSizes.weekTableHourCellSeparator,
              cellHeight: AppSizes.weekTableCellHeight,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _createCells(BuildContext context) => List<SizedBox>.generate(
        DateUtil.hoursPerDay - 1,
        (i) => SizedBox(
          width: AppSizes.weekTableHourCellWidth,
          height: AppSizes.weekTableCellHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _formatHours(i + 1),
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              const SizedBox(
                width: AppSizes.spacing + AppSizes.weekTableHourCellSeparator,
              ),
            ],
          ),
        ),
      );

  _formatHours(int hour) => hour < 10 ? '0$hour:00' : '$hour:00';
}
