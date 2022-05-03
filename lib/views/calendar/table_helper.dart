import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../util/event_graph_intersection_util.dart';
import '../../providers/events_provider.dart';
import '../../providers/date_provider.dart';
import '../../models/week_day_events.dart';
import '../../util/event_graph_util.dart';
import '../../models/calendar_type.dart';
import '../../resources/constants.dart';
import '../../util/calendar_util.dart';
import '../../models/event_type.dart';
import '../../util/date_util.dart';
import '../../models/event.dart';
import 'week_table_header_cell.dart';
import 'day_table_header_cell.dart';
import 'calendar_table_cell.dart';
import 'event_graph.dart';

class TableHelper {
  TableHelper._privateConstructor();

  static final instance = TableHelper._privateConstructor();

  final _weekKey = UniqueKey();
  final _dayKey = UniqueKey();

  int getCellCount(BuildContext context) => CalendarUtil.isWeekCalendar(context)
      ? DateTime.daysPerWeek
      : Constants.groupCount;

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
      CalendarUtil.isWeekCalendarType(type) ? _weekKey : _dayKey;

  Map<int, TableColumnWidth> createColumnWidths(BuildContext context) {
    final cellCount = getCellCount(context);
    return Map<int, TableColumnWidth>.fromIterable(
      Iterable<int>.generate(cellCount),
      value: (_) => const FlexColumnWidth(),
    );
  }

  List<TableRow> createRows(BuildContext context, GlobalKey key) {
    final cellCount = getCellCount(context);
    return List<TableRow>.generate(
      DateUtil.hoursPerDay,
      (i) => _createTableRow(key, i == 0, cellCount),
    );
  }

  List<EventGraph> createGraphics(BuildContext context, double cellWidth) =>
      CalendarUtil.isWeekCalendar(context)
          ? _createWeekTableGraphics(
              context,
              cellWidth,
            )
          : _createDayTableGraphics(
              context,
              cellWidth,
            );

  List<Widget> createHeaderCells(BuildContext context) =>
      CalendarUtil.isWeekCalendar(context)
          ? _createWeekHeaderCells(context)
          : _createDayHeaderCells(context);

  TableRow _createTableRow(
    GlobalKey key,
    bool isFirstRow,
    int cellCount,
  ) =>
      TableRow(
        children: List<CalendarTableCell>.generate(
          cellCount,
          (i) => CalendarTableCell(
            key: isFirstRow && i == 0 ? key : null,
          ),
        ),
      );

  List<EventGraph> _createWeekTableGraphics(
    BuildContext context,
    double cellWidth,
  ) {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final selectedDate = dateProvider.selectedDate;
    final allWeekDayEvents = eventsProvider.getAllWeekDayEvents(selectedDate);
    final List<EventGraph> graphics = [];
    EventGraphIntersectionUtil.instance.clear();
    for (var weekDayEvents in allWeekDayEvents) {
      _addWeekDayEventsGraphics(
        weekDayEvents: weekDayEvents,
        date: selectedDate,
        cellWidth: cellWidth,
        graphics: graphics,
      );
    }
    return graphics;
  }

  _addWeekDayEventsGraphics({
    required WeekDayEvents weekDayEvents,
    required DateTime date,
    required double cellWidth,
    required List<EventGraph> graphics,
  }) {
    final group = _groupEvents(weekDayEvents.weekDay, weekDayEvents.events);
    final entries = group.entries.toList();
    for (int i = 0; i < entries.length; i++) {
      final groupEvents = entries[i].value;
      for (var event in groupEvents) {
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
  }

  Map<EventType, List<Event>> _groupEvents(int weekDay, List<Event> events) {
    final Map<EventType, List<Event>> group = {};
    for (var type in EventType.values) {
      final List<Event> list = [];
      for (var event in events) {
        if (type == EventType.a) {
          EventGraphIntersectionUtil.instance.check(weekDay, event);
        }
        if (event.type == type) {
          list.add(event);
        }
      }
      group.putIfAbsent(type, () => list);
    }
    return group;
  }

  List<EventGraph> _createDayTableGraphics(
    BuildContext context,
    double cellWidth,
  ) {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final selectedDate = dateProvider.selectedDate;
    final events = eventsProvider.getDayEvents(selectedDate);
    final List<EventGraph> graphics = [];
    for (var event in events) {
      final size = EventGraphUtil.instance.calculateSizeForDayCalendar(
        event: event,
        date: selectedDate,
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
        WeekTableHeaderCell(
          weekDayDate: weekDayDate,
        ),
      );
    }
    return cells;
  }

  List<Widget> _createDayHeaderCells(BuildContext context) =>
      List<Widget>.generate(
        Constants.groupCount,
        (i) => DayTableHeaderCell(
          eventType: EventType.values[i],
        ),
      );
}
