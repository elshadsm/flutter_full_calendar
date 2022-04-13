import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/event.dart';

class WeekTableGraphText extends StatelessWidget {
  final Event event;
  final Color color;

  const WeekTableGraphText({
    Key? key,
    required this.event,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: '${event.title}\n',
          style: Theme.of(context).textTheme.caption!.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
          children: [
            TextSpan(
              text: '${DateFormat.Hm().format(event.from)} - '
                  '${DateFormat.Hm().format(event.to)}',
              style: Theme.of(context).textTheme.overline!.copyWith(
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
