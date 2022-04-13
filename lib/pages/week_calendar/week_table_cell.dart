import 'package:flutter/material.dart';

import '../../resources/sizes.dart';

class WeekTableCell extends StatelessWidget {
  final String? text;

  const WeekTableCell({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.weekTableCellHeight,
    );
  }
}
