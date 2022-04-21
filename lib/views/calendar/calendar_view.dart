import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/calendar_type_provider.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';
import 'calendar_navigation_bar.dart';
import 'calendar_table_header.dart';
import 'calendar_table.dart';
import 'hours_column.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final ScrollController _scrollController;

  var _scrolled = false;

  @override
  void initState() {
    super.initState();
    _initScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarTypeProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: AppSizes.spacingS,
            thickness: AppSizes.spacingS,
            color: AppColors.darkYellow,
          ),
          const CalendarNavigationBar(),
          const Divider(
            color: AppColors.dividerBackground,
            height: AppSizes.dividerSize,
            thickness: AppSizes.dividerSize,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: AppSizes.spacingL,
              right: AppSizes.spacingL,
            ),
            child: CalendarTableHeader(
              showBottomBorder: _scrolled,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                right: AppSizes.spacingL,
                bottom: AppSizes.spacingL,
              ),
              controller: _scrollController,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HoursColumn(),
                  Expanded(
                    child: CalendarTable(
                      calendarType: provider.type,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _initScrollController() {
    _scrollController = ScrollController()
      ..addListener(() {
        final scrolled = _scrollController.offset > 0;
        if (_scrolled != scrolled) {
          setState(() => _scrolled = scrolled);
        }
      });
  }
}
