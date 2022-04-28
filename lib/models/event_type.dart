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

  int get binary {
    switch (this) {
      case EventType.a:
        return 32;
      case EventType.b:
        return 16;
      case EventType.c:
        return 8;
      case EventType.d:
        return 4;
      case EventType.e:
        return 2;
      default:
        return 1;
    }
  }
}
