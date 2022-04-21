import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/events_provider.dart';
import '../../providers/date_provider.dart';
import '../../util/event_graph_util.dart';
import '../../models/calendar_type.dart';
import '../../util/date_util.dart';
import 'calendar_table_cell.dart';
import 'event_graph.dart';

class TableHelper {
  TableHelper._privateConstructor();

  static final instance = TableHelper._privateConstructor();

  final _weekKey = UniqueKey();
  final _dayKey = UniqueKey();

  UniqueKey getTableKey(CalendarType type) =>
      type == CalendarType.week ? _weekKey : _dayKey;

  Map<int, TableColumnWidth> createColumnWidths(CalendarType type) {
    return type == CalendarType.week
        ? _createWeekTableColumnWidths()
        : _createDayTableColumnWidths();
  }

  List<TableRow> createRows(CalendarType type, GlobalKey key) {
    return type == CalendarType.week
        ? _createWeekTableRows(key)
        : _createDayTableRows(key);
  }

  List<EventGraph> createGraphics(
    BuildContext context,
    CalendarType type,
    double cellWidth,
  ) {
    return type == CalendarType.week
        ? TableHelper.instance._createWeekTableGraphics(
            context,
            cellWidth,
          )
        : TableHelper.instance._createDayTableGraphics(
            context,
            cellWidth,
          );
  }

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
}
