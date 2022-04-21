enum EventType {
  a,
  b,
  c,
  d,
  e,
  f,
}

extension EventTypeExtension on EventType {
  String get value {
    switch (this) {
      case EventType.a:
        return 'A';
      case EventType.b:
        return 'B';
      case EventType.c:
        return 'C';
      case EventType.d:
        return 'D';
      case EventType.e:
        return 'E';
      default:
        return 'F';
    }
  }
}
