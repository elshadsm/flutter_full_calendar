import 'package:flutter/material.dart';

import '../../models/event_graph_size.dart';
import '../../util/event_graph_util.dart';
import '../../resources/sizes.dart';
import '../../models/event.dart';
import 'event_graph_text.dart';
import 'event_dialog.dart';

class EventGraph extends StatelessWidget {
  final Event event;
  final EventGraphSize size;

  const EventGraph({
    Key? key,
    required this.event,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = EventGraphUtil.instance.getColor(event);
    final borderRadius = _createBorderRadius(size);
    return Positioned(
      left: size.left,
      top: size.top,
      child: Material(
        borderRadius: borderRadius,
        child: InkWell(
          onTap: () => _handleTap(
            context,
            color.border,
          ),
          customBorder: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          child: Ink(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.all(AppSizes.spacingS),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                width: AppSizes.spacingXxs,
                color: color.border,
              ),
              color: color.background,
            ),
            child: EventGraphText(
              event: event,
              color: color.text,
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _createBorderRadius(EventGraphSize size) {
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

  _handleTap(
    BuildContext context,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (_) => EventDialog(
        event: event,
        color: color,
      ),
    );
  }
}
