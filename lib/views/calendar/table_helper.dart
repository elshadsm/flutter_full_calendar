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
import '../../models/event.dart';
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
      final group = _groupEvents(weekDayEvents.events);
      final entries = group.entries.toList();
      for (int i = 0; i < entries.length; i++) {
        final currentGroupEvents = entries[i].value;
        for (var event in currentGroupEvents) {
          if (event.constraints.relationCount == 0) {
            _findRelationships(event, i, 0, entries);
          }
          _addWeekTableGraphics(
            event: event,
            date: date,
            weekDay: weekDayEvents.weekDay,
            cellWidth: cellWidth,
            graphics: graphics,
          );
        }
      }
    }
    return graphics;
  }

  _addWeekTableGraphics({
    required Event event,
    required DateTime date,
    required int weekDay,
    required double cellWidth,
    required List<EventGraph> graphics,
  }) {
    final size = EventGraphUtil.instance.calculateSizeForWeekCalendar(
      event: event,
      date: date,
      weekDay: weekDay,
      cellWidth: cellWidth,
    );
    graphics.add(
      EventGraph(
        event: event,
        size: size,
      ),
    );
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

  Map<EventType, List<Event>> _groupEvents(List<Event> events) {
    final Map<EventType, List<Event>> group = {};
    for (var type in EventType.values) {
      final List<Event> list = [];
      for (var event in events) {
        if (event.type == type) {
          list.add(event);
        }
      }
      group.putIfAbsent(type, () => list);
    }
    return group;
  }

  int _findRelationships(
    Event event,
    int groupIndex,
    int relationCount,
    List<MapEntry<EventType, List<Event>>> entries,
  ) {
    int count = relationCount;
    _updateEventRelationCount(event, count);
    _updateEventHorizontalIndex(event, count);
    if (groupIndex >= entries.length - 1) {
      return count;
    }
    final nextGroupEvents = entries[groupIndex + 1].value;
    if (nextGroupEvents.isEmpty) {
      return _findRelationships(
        event,
        groupIndex + 1,
        relationCount,
        entries,
      );
    }
    for (var nextGroupEvent in nextGroupEvents) {
      if (event.to.isBefore(nextGroupEvent.from)) {
        break;
      }
      if (event.from.isAfter(nextGroupEvent.to)) {
        continue;
      }
      final result = _findRelationships(
        nextGroupEvent,
        groupIndex + 1,
        relationCount + 1,
        entries,
      );
      if (result > count) {
        count = result;
        _updateEventRelationCount(event, count);
      }
    }
    return count;
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

  _updateEventRelationCount(Event event, int count) {
    final relationCount = event.constraints.relationCount;
    event.constraints.relationCount =
        relationCount > count ? relationCount : count;
  }

  _updateEventHorizontalIndex(Event event, int index) {
    final horizontalIndex = event.constraints.horizontalIndex;
    event.constraints.horizontalIndex =
        horizontalIndex > index ? horizontalIndex : index;
  }
}
