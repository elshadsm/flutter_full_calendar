import 'dart:math';

import 'package:jiffy/jiffy.dart';

import '../models/event_type.dart';
import '../models/event.dart';
import 'date_util.dart';

class EventsUtil {
  EventsUtil._privateConstructor() {
    events.addAll(_createMondayEvents());
    _generateRandomEvents();
  }

  static final instance = EventsUtil._privateConstructor();

  List<Event> events = [];

  void _generateRandomEvents() {
    final startOfWeek = Jiffy().startOf(Units.WEEK).dateTime;
    for (int i = 1; i < 21; i++) {
      final date = startOfWeek.add(
        Duration(days: i + 1),
      );
      events.addAll(
        _createEvents(EventType.a, date),
      );
      events.addAll(
        _createEvents(EventType.b, date),
      );
      events.addAll(
        _createEvents(EventType.c, date),
      );
      events.addAll(
        _createEvents(EventType.d, date),
      );
      events.addAll(
        _createEvents(EventType.e, date),
      );
      events.addAll(
        _createEvents(EventType.f, date),
      );
    }
  }

  List<Event> _createEvents(EventType type, DateTime date) {
    List<Event> events = [];
    var random = Random();
    var number = 0;
    var oldNumber = 0;
    while (number < DateUtil.hoursPerDay - 8) {
      oldNumber = number + random.nextInt(5);
      number = oldNumber + random.nextInt(5) + 1;
      events.add(
        Event(
          id: 'id',
          title: 'Event ${type.index}$number',
          from: date.add(
            Duration(
              hours: oldNumber,
              minutes: 10,
            ),
          ),
          to: date.add(
            Duration(
              hours: number,
            ),
          ),
          type: type,
        ),
      );
    }
    return events;
  }

  List<Event> _createMondayEvents() {
    List<Event> list = [];
    final startOfWeek = DateUtil.getStartOfTheWeek(DateTime.now()).add(
      const Duration(
        hours: 12,
      ),
    );
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j <= i; j++) {
        list.add(
          _createMondayEvent(
            EventType.values[j],
            startOfWeek.add(Duration(hours: i)),
          ),
        );
      }
    }
    return list;
  }

  Event _createMondayEvent(EventType type, DateTime date) => Event(
        id: 'id',
        title: 'Monday event ${date.hour}${date.minute}',
        from: date,
        to: date
            .add(
              const Duration(
                hours: 1,
              ),
            )
            .subtract(
              const Duration(
                minutes: 5,
              ),
            ),
        type: type,
      );
}
