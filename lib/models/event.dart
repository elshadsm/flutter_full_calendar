import 'event_constraints.dart';
import 'event_type.dart';

class Event {
  final String id;
  final String title;
  final DateTime from;
  final DateTime to;
  final EventType type;
  EventConstraints _constraints = EventConstraints();

  EventConstraints get constraints => _constraints;

  Event({
    required this.id,
    required this.title,
    required this.from,
    required this.to,
    required this.type,
  });

  Event clone() => Event(
        id: id,
        title: title,
        from: from,
        to: to,
        type: type,
      ).._constraints = constraints.clone();
}
