import 'dart:math';

import 'package:jiffy/jiffy.dart';

import '../models/event_type.dart';
import '../models/event.dart';
import 'date_util.dart';

class EventsUtil {
  EventsUtil._privateConstructor() {
    _generateRandomEvents();
  }

  static final instance = EventsUtil._privateConstructor();

  List<Event> events = [];

  void _generateRandomEvents() {
    for (int i = 0; i < 7; i++) {
      final date = Jiffy().startOf(Units.WEEK).dateTime.add(
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
    while (number < DateUtil.hoursPerDay - 4) {
      oldNumber = number;
      number = number + random.nextInt(4) + 1;
      events.add(
        Event(
          id: 'id',
          title: 'Event $number',
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
}
