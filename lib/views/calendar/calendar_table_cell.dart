import 'package:flutter/material.dart';

import '../../resources/sizes.dart';

class CalendarTableCell extends StatelessWidget {
  const CalendarTableCell({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSizes.tableCellHeight,
    );
  }
}
