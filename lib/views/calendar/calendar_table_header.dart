import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/horizontal_table_separators.dart';
import '../../providers/date_provider.dart';
import '../../resources/sizes.dart';
import 'table_helper.dart';

class CalendarTableHeader extends StatelessWidget {
  final bool showBottomBorder;

  const CalendarTableHeader({
    Key? key,
    required this.showBottomBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<DateProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.hourCellWidth,
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: TableHelper.instance.createHeaderCells(
              context,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: HorizontalTableSeparators(
                cellCount: TableHelper.instance.getCellCount(context),
                cellHeight: AppSizes.tableHeaderSeparator,
                showBottomBorder: showBottomBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
