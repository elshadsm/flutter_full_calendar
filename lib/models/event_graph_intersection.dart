class EventGraphIntersection {
  DateTime from;
  DateTime to;
  final SharedRelation relation;

  EventGraphIntersection({
    required this.from,
    required this.to,
    required this.relation,
  });
}

class SharedRelation {
  int binary;

  int get value {
    final string = binary.toRadixString(2);
    return '1'.allMatches(string).length - 1;
  }

  SharedRelation([
    this.binary = 0,
  ]);

  SharedRelation clone() => SharedRelation(binary);
}
