import 'package:flutter/material.dart';

import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class HorizontalTableSeparators extends StatelessWidget {
  final int cellCount;
  final double cellHeight;
  final bool showBottomBorder;

  const HorizontalTableSeparators({
    Key? key,
    required this.cellCount,
    required this.cellHeight,
    required this.showBottomBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderSide = BorderSide(
      width: AppSizes.dividerSize,
      color: AppColors.dividerBackground,
    );
    return Table(
      border: TableBorder(
        left: borderSide,
        right: borderSide,
        bottom: showBottomBorder ? borderSide : BorderSide.none,
        verticalInside: borderSide,
      ),
      columnWidths: _createTableColumnWidths(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _createTableRow(),
      ],
    );
  }

  Map<int, TableColumnWidth> _createTableColumnWidths() =>
      Map<int, TableColumnWidth>.fromIterable(
        Iterable<int>.generate(cellCount),
        value: (_) => const FlexColumnWidth(),
      );

  TableRow _createTableRow() => TableRow(
        children: List<SizedBox>.generate(
          cellCount,
          (_) => SizedBox(
            height: cellHeight,
          ),
        ),
      );
}
