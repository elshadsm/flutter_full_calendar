import 'package:flutter/material.dart';

import '../models/week_day_events.dart';
import '../util/events_util.dart';
import '../util/date_util.dart';
import '../models/event.dart';

class EventsProvider extends ChangeNotifier {
  List<Event> _events = [];

  List<WeekDayEvents> getAllWeekDayEvents(DateTime date) {
    _initEvents();
    final events = _extractSelectedWeekEvents(date);
    return _createAllWeekDayEvents(date, events);
  }

  List<Event> getDayEvents(DateTime date) {
    _initEvents();
    return _extractDayEvents(date);
  }

  _initEvents() {
    _events = EventsUtil.instance.events;
    _events.sort((a, b) => a.from.compareTo(b.from));
  }

  List<Event> _extractSelectedWeekEvents(DateTime date) {
    final List<Event> events = [];
    final startOfTheWeek = DateUtil.getStartOfTheWeek(date);
    final endOfTheWeek = DateUtil.getEndOfTheWeek(date);
    for (var event in _events) {
      if (event.from.isAfter(endOfTheWeek)) {
        break;
      }
      if (event.to.isBefore(startOfTheWeek)) {
        continue;
      }
      events.add(event);
    }
    return events;
  }

  List<Event> _extractDayEvents(DateTime date) {
    final List<Event> events = [];
    final starOfDay = DateUtil.getStartOfDay(date);
    final endOfDay = DateUtil.getEndOfDay(date);
    for (var event in _events) {
      if (event.from.isAfter(endOfDay)) {
        break;
      }
      if (event.to.isBefore(starOfDay)) {
        continue;
      }
      events.add(event);
    }
    return events;
  }

  List<WeekDayEvents> _createAllWeekDayEvents(
    DateTime date,
    List<Event> events,
  ) {
    final List<WeekDayEvents> allWeekDayEvents = [];
    for (int i = 1; i <= DateTime.daysPerWeek; i++) {
      final weekDayEvents = WeekDayEvents(weekDay: i);
      _updateWeekDayEvents(date, events, weekDayEvents);
      allWeekDayEvents.add(weekDayEvents);
    }
    return allWeekDayEvents;
  }

  _updateWeekDayEvents(
    DateTime date,
    List<Event> events,
    WeekDayEvents weekDayEvents,
  ) {
    final startOfTheWeek = DateUtil.getStartOfTheWeek(date);
    final weekDayDate = startOfTheWeek.add(
      Duration(days: weekDayEvents.weekDay - 1),
    );
    final startOfTheWeekDay = DateUtil.getStartOfDay(weekDayDate);
    final endOfTheWeekDay = DateUtil.getEndOfDay(weekDayDate);
    for (var event in events) {
      if (event.to.isBefore(startOfTheWeekDay)) {
        continue;
      }
      if (event.from.isAfter(endOfTheWeekDay)) {
        continue;
      }
      weekDayEvents.events.add(event);
    }
  }
}
