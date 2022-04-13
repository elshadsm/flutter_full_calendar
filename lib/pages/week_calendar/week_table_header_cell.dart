import 'package:flutter/material.dart';

import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class WeekTableHeaderCell extends StatelessWidget {
  final String week;
  final int day;
  final bool isToday;

  const WeekTableHeaderCell({
    Key? key,
    required this.week,
    required this.day,
    required this.isToday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            week,
            style: textTheme.caption?.copyWith(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.spacing),
          TextButton(
            child: Text(
              day.toString(),
              style: textTheme.headline5?.copyWith(
                color: isToday ? Colors.white : AppColors.blue,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(AppSizes.spacingL),
              backgroundColor: isToday ? AppColors.blue : null,
              shape: const CircleBorder(),
            ),
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.spacingS),
        ],
      ),
    );
  }
}
