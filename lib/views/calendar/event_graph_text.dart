import 'package:flutter/material.dart';

import '../../util/event_graph_util.dart';
import '../../models/event.dart';

class EventGraphText extends StatelessWidget {
  final Event event;
  final Color color;

  const EventGraphText({
    Key? key,
    required this.event,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        text: TextSpan(
          text: '${event.title}\n',
          style: textTheme.caption!.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: EventGraphUtil.instance.getHourText(event),
              style: textTheme.overline!.copyWith(
                color: color,
                letterSpacing: 0.25,
                wordSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
