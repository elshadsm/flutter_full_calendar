import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../util/event_graph_intersection_util.dart';
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
    EventGraphIntersectionUtil.instance.clear();
    for (var weekDayEvents in allWeekDayEvents) {
      final group = _groupEvents(weekDayEvents.weekDay, weekDayEvents.events);
      final entries = group.entries.toList();
      for (int i = 0; i < entries.length; i++) {
        final currentGroupEvents = entries[i].value;
        for (var event in currentGroupEvents) {
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

  // SharedRelation _findRelationships(
  //   Event event,
  //   int groupIndex,
  //   SharedRelation? childRelation,
  //   List<MapEntry<EventType, List<Event>>> groups,
  // ) {
  //   _printProcess(event, '_groupEvents');
  //   if (event.constraints.relationReference != null) {
  //     _printProcess(event, 'reference is not null');
  //     return event.constraints.relationReference!;
  //   }
  //   if (groupIndex >= groups.length - 1) {
  //     if (childRelation != null) {
  //       childRelation.binary = childRelation.binary | event.type.binary;
  //       event.constraints.relationReference = childRelation;
  //     } else {
  //       event.constraints.relationReference = SharedRelation(event.type.binary);
  //     }
  //     _printProcess(event, 'groupIndex is last');
  //     return event.constraints.relationReference!;
  //   }
  //   final nextGroupEvents = groups[groupIndex + 1].value;
  //   if (nextGroupEvents.isEmpty) {
  //     _printProcess(event, 'next group events is empty');
  //     return _findRelationships(
  //       event,
  //       groupIndex + 1,
  //       childRelation,
  //       groups,
  //     );
  //   }
  //   for (var i = 0; i < nextGroupEvents.length; i++) {
  //     final nextGroupEvent = nextGroupEvents[i];
  //     if (event.to.isBefore(nextGroupEvent.from)) {
  //       _printProcess(event, '*** to is before from ***');
  //       return _findRelationships(
  //         event,
  //         groupIndex + 1,
  //         childRelation,
  //         groups,
  //       );
  //     }
  //     if (event.from.isAfter(nextGroupEvent.to)) {
  //       _printProcess(event, '*** from is after to ***');
  //       print('- FROM: ${event.from}');
  //       print('- TO: ${nextGroupEvent.to}');
  //       if (i == nextGroupEvents.length - 1) {
  //         return _findRelationships(
  //           event,
  //           groupIndex + 1,
  //           childRelation,
  //           groups,
  //         );
  //       } else {
  //         continue;
  //       }
  //     }
  //     _printProcess(event, 'matcheddddddd');
  //     print('*** Parent is: ${nextGroupEvent.title}');
  //     final result = _findRelationships(
  //       nextGroupEvent,
  //       groupIndex + 1,
  //       event.constraints.relationReference,
  //       groups,
  //     );
  //     _checkFindRelationshipsResult(event, result);
  //   }
  //   print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  //   return event.constraints.relationReference!;
  // }

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

// _checkFindRelationshipsResult(
//   Event event,
//   SharedRelation result,
// ) {
//   _printProcess(event, 'handle result');
//   final reference = event.constraints.relationReference;
//   if (reference == null) {
//     print('===================  is nullllll =======================');
//     result.binary = result.binary | event.type.binary;
//     event.constraints.relationReference = result;
//     print('===================  is nullllll =======================');
//   } else {
//     print('*********************************************');
//     print('reference.binary: ${reference.binary}');
//     print('result.binary: ${result.binary}');
//     reference.binary = reference.binary | result.binary;
//     print('result: ${reference.binary}');
//     print('*********************************************');
//   }
// }

// _printProcess(Event event, String process) {
//   print('-------------------- $process --------------------');
//   print('title: ${event.title} type: ${event.type.value}');
//   print('horizontalIndex: ${event.constraints.horizontalIndex}');
//   print('reference: ${event.constraints.relationReference}');
//   print(
//     'binary: ${event.constraints.relationReference?.binary.toRadixString(2)}',
//   );
//   print(
//     'value: ${event.constraints.relationReference?.value}',
//   );
//   print('-------------------- $process --------------------');
// }
}
