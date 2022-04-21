import 'package:flutter/material.dart';

import '../models/calendar_type.dart';

class CalendarTypeProvider extends ChangeNotifier {
  CalendarType _type = CalendarType.week;

  CalendarType get type => _type;

  set type(CalendarType type) {
    _type = type;
    notifyListeners();
  }
}
