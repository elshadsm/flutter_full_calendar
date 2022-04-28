import '../models/event_graph_intersection.dart';
import '../models/event_type.dart';
import '../models/event.dart';

class EventGraphIntersectionUtil {
  EventGraphIntersectionUtil._privateConstructor();

  static final instance = EventGraphIntersectionUtil._privateConstructor();

  final Map<int, List<EventGraphIntersection>> _map = {};

  void check(int weekDay, Event event) {
    final list = _getList(weekDay);
    for (var intersection in list) {
      if (event.to.isBefore(intersection.from)) {
        break;
      }
      if (event.from.isAfter(intersection.to)) {
        continue;
      }
      if (event.from.isBefore(intersection.from)) {
        intersection.from = event.from;
      }
      if (event.to.isAfter(intersection.to)) {
        intersection.to = event.to;
      }
      intersection.relation.binary =
          intersection.relation.binary | event.type.binary;
      return;
    }
    _addEvent(weekDay, event);
  }

  SharedRelation getRelation(int weekDay, Event event) {
    final list = _getList(weekDay);
    for (var intersection in list) {
      if (event.to.isBefore(intersection.from)) {
        break;
      }
      if (event.from.isAfter(intersection.to)) {
        continue;
      }
      return intersection.relation;
    }
    return SharedRelation(0);
  }

  int binaryToHorizontalIndex(int binary, EventType type) {
    var index = 0;
    final string = binary.toRadixString(2).padLeft(6, '0');
    for (var i = 0; i < type.index; i++) {
      if (string[i] == '1') {
        index++;
      }
    }
    return index;
  }

  clear() {
    _map.clear();
  }

  _addEvent(int weekDay, Event event) {
    final list = _getList(weekDay);
    list.add(
      EventGraphIntersection(
        from: event.from,
        to: event.to,
        relation: SharedRelation(event.type.binary),
      ),
    );
    _map[weekDay] = list;
  }

  _getList(int weekDay) => _map[weekDay] ?? [];
}
