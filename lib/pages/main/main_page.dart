import 'package:flutter/material.dart';

import '../../views/calendar/calendar_view.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Calendar Component'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacingL,
          horizontal: 128,
        ),
        color: AppColors.lightGrey,
        child: const CalendarView(),
      ),
    );
  }
}
