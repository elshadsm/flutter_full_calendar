import 'package:flutter/material.dart';

import '../../widgets/horizontal_table_separators.dart';
import '../../resources/constants.dart';
import '../../models/event_type.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class DayTableHeader extends StatelessWidget {
  final bool showBottomBorder;

  const DayTableHeader({
    Key? key,
    required this.showBottomBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.hourCellWidth,
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _createCells(context),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: HorizontalTableSeparators(
                cellCount: Constants.groupCount,
                cellHeight: AppSizes.tableHeaderSeparator,
                showBottomBorder: showBottomBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createCells(BuildContext context) => List<Widget>.generate(
        Constants.groupCount,
        (i) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingL),
            child: Center(
              child: Text(
                'Room ${EventType.values[i].value}',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ),
      );
}
