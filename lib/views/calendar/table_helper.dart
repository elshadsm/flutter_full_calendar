import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/events_provider.dart';
import '../../providers/date_provider.dart';
import '../../util/event_graph_util.dart';
import '../../models/calendar_type.dart';
import '../../resources/constants.dart';
import '../../util/calendar_util.dart';
import '../../models/event_type.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';
import '../../util/date_util.dart';
import 'week_table_header_cell.dart';
import 'calendar_table_cell.dart';
import 'event_graph.dart';

class TableHelper {
  TableHelper._privateConstructor();

  static final instance = TableHelper._privateConstructor();

  final _weekKey = UniqueKey();
  final _dayKey = UniqueKey();

  String getNavigationTitle(
    BuildContext context,
    DateTime date,
  ) {
    final dateFormat = CalendarUtil.isWeekCalendar(context)
        ? DateFormat.yMMMM()
        : DateFormat.yMMMMd();
    return dateFormat.format(date);
  }

  UniqueKey getTableKey(CalendarType type) =>
      type == CalendarType.week ? _weekKey : _dayKey;

  Map<int, TableColumnWidth> createColumnWidths(BuildContext context) =>
      CalendarUtil.isWeekCalendar(context)
          ? _createWeekTableColumnWidths()
          : _createDayTableColumnWidths();

  List<TableRow> createRows(BuildContext context, GlobalKey key) =>
      CalendarUtil.isWeekCalendar(context)
          ? _createWeekTableRows(key)
          : _createDayTableRows(key);

  List<EventGraph> createGraphics(BuildContext context, double cellWidth) =>
      CalendarUtil.isWeekCalendar(context)
          ? TableHelper.instance._createWeekTableGraphics(
              context,
              cellWidth,
            )
          : TableHelper.instance._createDayTableGraphics(
              context,
              cellWidth,
            );

  List<Widget> createHeaderCells(BuildContext context) =>
      CalendarUtil.isWeekCalendar(context)
          ? _createWeekHeaderCells(context)
          : _createDayHeaderCells(context);

  int getHeaderCellCount(BuildContext context) =>
      CalendarUtil.isWeekCalendar(context)
          ? DateTime.daysPerWeek
          : Constants.groupCount;

  Map<int, TableColumnWidth> _createWeekTableColumnWidths() => const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
        5: FlexColumnWidth(),
        6: FlexColumnWidth(),
      };

  Map<int, TableColumnWidth> _createDayTableColumnWidths() => const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
        5: FlexColumnWidth(),
      };

  List<TableRow> _createWeekTableRows(GlobalKey key) => List<TableRow>.generate(
        DateUtil.hoursPerDay,
        (i) => _createWeekTableRow(key, i),
      );

  List<TableRow> _createDayTableRows(GlobalKey key) => List<TableRow>.generate(
        DateUtil.hoursPerDay,
        (i) => _createDayTableRow(key, i),
      );

  TableRow _createWeekTableRow(GlobalKey key, int i) => TableRow(
        children: [
          CalendarTableCell(
            key: i == 0 ? key : null,
          ),
          const CalendarTableCell(),
          const CalendarTableCell(),
          const CalendarTableCell(),
          const CalendarTableCell(),
          const CalendarTableCell(),
          const CalendarTableCell(),
        ],
      );

  TableRow _createDayTableRow(GlobalKey key, int i) => TableRow(
        children: [
          CalendarTableCell(
            key: i == 0 ? key : null,
          ),
          const CalendarTableCell(),
          const CalendarTableCell(),
          const CalendarTableCell(),
          const CalendarTableCell(),
          const CalendarTableCell(),
        ],
      );

  List<EventGraph> _createWeekTableGraphics(
    BuildContext context,
    double cellWidth,
  ) {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final date = dateProvider.selectedDate;
    final allWeekDayEvents = eventsProvider.getAllWeekDayEvents(date);
    final List<EventGraph> graphics = [];
    for (var weekDayEvents in allWeekDayEvents) {
      for (var event in weekDayEvents.events) {
        final size = EventGraphUtil.instance.calculateSizeForWeekCalendar(
          event: event,
          date: date,
          weekDay: weekDayEvents.weekDay,
          cellWidth: cellWidth,
        );
        graphics.add(
          EventGraph(
            event: event,
            size: size,
          ),
        );
      }
    }
    return graphics;
  }

  List<EventGraph> _createDayTableGraphics(
    BuildContext context,
    double cellWidth,
  ) {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final date = dateProvider.selectedDate;
    final events = eventsProvider.getDayEvents(date);
    final List<EventGraph> graphics = [];
    for (var event in events) {
      final size = EventGraphUtil.instance.calculateSizeForDayCalendar(
        event: event,
        date: date,
        cellWidth: cellWidth,
      );
      graphics.add(
        EventGraph(
          event: event,
          size: size,
        ),
      );
    }
    return graphics;
  }

  List<Widget> _createWeekHeaderCells(BuildContext context) {
    final provider = Provider.of<DateProvider>(context, listen: false);
    List<Widget> cells = [];
    final selectedDate = provider.selectedDate;
    final startOfTheWeek = DateUtil.getStartOfTheWeek(selectedDate);
    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      final weekDayDate = startOfTheWeek.add(
        Duration(days: i),
      );
      cells.add(
        WeekTableHeaderCell(weekDayDate: weekDayDate),
      );
    }
    return cells;
  }

  List<Widget> _createDayHeaderCells(BuildContext context) =>
      List<Widget>.generate(
        Constants.groupCount,
        (i) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingL),
            child: Center(
              child: Text(
                'Room ${EventType.values[i].value}',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ),
      );
}
