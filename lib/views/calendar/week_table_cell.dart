import 'package:flutter/material.dart';

import '../../resources/sizes.dart';

class WeekTableCell extends StatelessWidget {
  const WeekTableCell({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSizes.weekTableCellHeight,
    );
  }
}
