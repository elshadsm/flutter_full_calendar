import 'event_type.dart';

class Event {
  final String id;
  final String title;
  final DateTime from;
  final DateTime to;
  final EventType type;

  Event({
    required this.id,
    required this.title,
    required this.from,
    required this.to,
    required this.type,
  });
}
