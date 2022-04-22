import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class EventDialogDateText extends StatelessWidget {
  final String label;
  final DateTime date;

  const EventDialogDateText({
    Key? key,
    required this.label,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: AppSizes.icon + AppSizes.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.caption!.copyWith(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.spacingXs),
          Text(
            DateFormat('EEEE, MMMM dd, y - HH:mm').format(date),
            style: textTheme.subtitle2!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
