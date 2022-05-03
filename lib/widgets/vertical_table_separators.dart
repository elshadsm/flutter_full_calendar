import 'package:flutter/material.dart';

import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class VerticalTableSeparators extends StatelessWidget {
  final int cellCount;
  final double cellWidth;
  final double cellHeight;

  const VerticalTableSeparators({
    Key? key,
    required this.cellCount,
    required this.cellWidth,
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
        top: borderSide,
        bottom: borderSide,
        horizontalInside: borderSide,
      ),
      columnWidths: {
        0: FixedColumnWidth(cellWidth),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _createTableRows(),
    );
  }

  List<TableRow> _createTableRows() => List<TableRow>.generate(
        cellCount,
        (_) => TableRow(
          children: [
            SizedBox(
              width: cellWidth,
              height: cellHeight,
            ),
          ],
        ),
      );
}
