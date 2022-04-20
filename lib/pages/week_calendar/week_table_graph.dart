import 'package:flutter/material.dart';

import '../../models/week_graph_size.dart';
import '../../util/week_graph_util.dart';
import '../../resources/sizes.dart';
import '../../models/event.dart';
import 'week_table_graph_text.dart';

class WeekTableGraph extends StatelessWidget {
  final Event event;
  final int weekDay;
  final double cellWidth;

  const WeekTableGraph({
    Key? key,
    required this.event,
    required this.weekDay,
    required this.cellWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = WeekGraphUtil.instance.calculateSize(
      context: context,
      event: event,
      weekDay: weekDay,
      cellWidth: cellWidth,
    );
    final color = WeekGraphUtil.instance.getColor(event);
    return Positioned(
      left: size.left,
      top: size.top,
      child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(AppSizes.spacingS),
        decoration: BoxDecoration(
          borderRadius: _createBorderRadius(size),
          border: Border.all(
            width: AppSizes.spacingXxs,
            color: color.border,
          ),
          color: color.background,
        ),
        child: WeekTableGraphText(
          event: event,
          color: color.text,
        ),
      ),
    );
  }

  BorderRadius _createBorderRadius(WeekGraphSize size) {
    const radius = Radius.circular(
      AppSizes.cardCornerRadius,
    );
    if (size.continueFromPrevDay) {
      return const BorderRadius.vertical(bottom: radius);
    }
    if (size.continueToNextDay) {
      return const BorderRadius.vertical(top: radius);
    }
    return const BorderRadius.all(radius);
  }
}
