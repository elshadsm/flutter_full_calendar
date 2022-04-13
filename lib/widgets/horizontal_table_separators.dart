import 'package:flutter/material.dart';

import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class HorizontalTableSeparators extends StatelessWidget {
  final int cellCount;
  final double cellHeight;

  const HorizontalTableSeparators({
    Key? key,
    required this.cellCount,
    required this.cellHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderSide = BorderSide(
      width: AppSizes.dividerSize,
      color: AppColors.dividerBackground,
    );
    return Table(
      border: const TableBorder(
        left: borderSide,
        right: borderSide,
        verticalInside: borderSide,
      ),
      columnWidths: _createTableColumnWidths(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _createTableRow(),
      ],
    );
  }

  Map<int, TableColumnWidth> _createTableColumnWidths() {
    final Map<int, TableColumnWidth> map = {};
    for (int i = 0; i < cellCount; i++) {
      map[i] = const FlexColumnWidth();
    }
    return map;
  }

  TableRow _createTableRow() => TableRow(
        children: List<SizedBox>.generate(
          cellCount,
          (_) => SizedBox(
            height: cellHeight,
          ),
        ),
      );
}
