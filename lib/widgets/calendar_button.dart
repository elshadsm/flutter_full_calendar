import 'package:flutter/material.dart';

import '../../resources/colors.dart';
import '../resources/sizes.dart';

class CalendarButton extends StatelessWidget {
  final EdgeInsets? padding;
  final BorderRadiusGeometry borderRadius;
  final Widget? child;
  final Color? background;
  final VoidCallback? onPressed;

  const CalendarButton({
    Key? key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSizes.buttonHorizontalPadding,
      vertical: AppSizes.buttonVerticalPadding,
    ),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppSizes.spacingS),
    ),
    this.child,
    this.background = AppColors.blue,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: Size.zero,
        padding: padding,
        primary: background,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      child: SizedBox(
        height: 24,
        child: Center(
          child: child,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
