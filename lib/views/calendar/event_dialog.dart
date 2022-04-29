import 'package:flutter/material.dart';

import '../../models/event_type.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';
import '../../models/event.dart';
import 'event_dialog_date_text.dart';

class EventDialog extends StatelessWidget {
  final Event event;
  final Color color;

  const EventDialog({
    Key? key,
    required this.event,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.all(AppSizes.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: AppSizes.icon,
                      color: color,
                    ),
                    const SizedBox(width: AppSizes.spacingL),
                    Expanded(
                      child: Text(
                        'Room ${event.type.value}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: color,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingL),
                Text(
                  event.title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText,
                      ),
                ),
                const SizedBox(height: AppSizes.spacingL),
                EventDialogDateText(
                  label: 'From',
                  date: event.from,
                ),
                const SizedBox(height: AppSizes.spacing),
                EventDialogDateText(
                  label: 'To',
                  date: event.to,
                ),
              ],
            ),
          ),
          Positioned(
            top: AppSizes.spacing,
            right: AppSizes.spacing,
            child: InkResponse(
              radius: AppSizes.spacingL,
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                size: AppSizes.icon,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
