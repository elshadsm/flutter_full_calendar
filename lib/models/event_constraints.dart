class EventConstraints {
  int relationCount;
  int horizontalIndex;

  EventConstraints({
    this.relationCount = 0,
    this.horizontalIndex = 0,
  });

  EventConstraints clone() => EventConstraints(
        relationCount: relationCount,
        horizontalIndex: horizontalIndex,
      );
}
