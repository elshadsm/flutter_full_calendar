import 'package:flutter/material.dart';

import '../../models/event_type.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class DayTableHeaderCell extends StatelessWidget {
  final EventType eventType;

  const DayTableHeaderCell({
    Key? key,
    required this.eventType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingL),
        child: Center(
          child: Text(
            'Room ${eventType.value}',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}
